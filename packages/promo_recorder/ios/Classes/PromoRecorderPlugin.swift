import AVFoundation
import Flutter
import Photos
import ReplayKit
import UIKit

/// The app's own frames from ReplayKit, written as HEVC at the screen's full
/// resolution and a high bitrate, with the app's sound, then saved to Photos.
public class PromoRecorderPlugin: NSObject, FlutterPlugin {
  private let queue = DispatchQueue(label: "outrepd.promo.recorder")
  private var writer: AVAssetWriter?
  private var video: AVAssetWriterInput?
  private var audio: AVAssetWriterInput?
  private var url: URL?
  private var started = false

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "outrepd/promo_recorder", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(PromoRecorderPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "start": start(result)
    case "stop": stop(result)
    default: result(FlutterMethodNotImplemented)
    }
  }

  private func start(_ result: @escaping FlutterResult) {
    let recorder = RPScreenRecorder.shared()
    guard recorder.isAvailable else {
      result(FlutterError(
        code: "unavailable", message: "Recording is not available on this phone", details: nil))
      return
    }
    if recorder.isRecording {
      result(nil)
      return
    }
    recorder.isMicrophoneEnabled = false

    // Portrait pixels, made even: the encoder takes whole pairs.
    let native = UIScreen.main.nativeBounds.size
    let width = Int(native.width) / 2 * 2
    let height = Int(native.height) / 2 * 2
    let url = FileManager.default.temporaryDirectory
      .appendingPathComponent("outrepd-take-\(Int(Date().timeIntervalSince1970)).mp4")
    try? FileManager.default.removeItem(at: url)

    do {
      let writer = try AVAssetWriter(outputURL: url, fileType: .mp4)
      let video = AVAssetWriterInput(mediaType: .video, outputSettings: [
        AVVideoCodecKey: AVVideoCodecType.hevc,
        AVVideoWidthKey: width,
        AVVideoHeightKey: height,
        AVVideoCompressionPropertiesKey: [
          AVVideoAverageBitRateKey: 40_000_000,
          AVVideoExpectedSourceFrameRateKey: 60,
          AVVideoMaxKeyFrameIntervalKey: 60,
        ],
      ])
      video.expectsMediaDataInRealTime = true
      let audio = AVAssetWriterInput(mediaType: .audio, outputSettings: [
        AVFormatIDKey: kAudioFormatMPEG4AAC,
        AVNumberOfChannelsKey: 2,
        AVSampleRateKey: 44_100,
        AVEncoderBitRateKey: 192_000,
      ])
      audio.expectsMediaDataInRealTime = true
      if writer.canAdd(video) { writer.add(video) }
      if writer.canAdd(audio) { writer.add(audio) }
      queue.sync {
        self.writer = writer
        self.video = video
        self.audio = audio
        self.url = url
        self.started = false
      }
    } catch {
      result(FlutterError(code: "writer", message: error.localizedDescription, details: nil))
      return
    }

    recorder.startCapture(handler: { [weak self] buffer, type, error in
      guard let self = self, error == nil else { return }
      self.queue.async { self.append(buffer, type) }
    }, completionHandler: { error in
      DispatchQueue.main.async {
        if let error = error {
          result(FlutterError(code: "refused", message: error.localizedDescription, details: nil))
        } else {
          result(nil)
        }
      }
    })
  }

  private func append(_ buffer: CMSampleBuffer, _ type: RPSampleBufferType) {
    guard let writer = writer, CMSampleBufferDataIsReady(buffer) else { return }
    if !started {
      // The film starts on a picture, never on sound.
      guard type == .video else { return }
      writer.startWriting()
      writer.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(buffer))
      started = true
    }
    guard writer.status == .writing else { return }
    switch type {
    case .video:
      if video?.isReadyForMoreMediaData == true { video?.append(buffer) }
    case .audioApp:
      if audio?.isReadyForMoreMediaData == true { audio?.append(buffer) }
    default:
      break
    }
  }

  private func stop(_ result: @escaping FlutterResult) {
    RPScreenRecorder.shared().stopCapture { [weak self] _ in
      guard let self = self else { return }
      self.queue.async {
        guard let writer = self.writer, let url = self.url, self.started else {
          self.reset()
          DispatchQueue.main.async { result(false) }
          return
        }
        self.video?.markAsFinished()
        self.audio?.markAsFinished()
        self.reset()
        writer.finishWriting {
          guard writer.status == .completed else {
            DispatchQueue.main.async {
              result(FlutterError(
                code: "writer", message: writer.error?.localizedDescription, details: nil))
            }
            return
          }
          self.save(url) { saved, message in
            DispatchQueue.main.async {
              if saved {
                result(true)
              } else {
                result(FlutterError(code: "photos", message: message, details: nil))
              }
            }
          }
        }
      }
    }
  }

  private func save(_ url: URL, _ done: @escaping (Bool, String?) -> Void) {
    PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
      guard status == .authorized || status == .limited else {
        done(false, "No permission to save to Photos")
        return
      }
      PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
      }) { ok, error in
        try? FileManager.default.removeItem(at: url)
        done(ok, error?.localizedDescription)
      }
    }
  }

  private func reset() {
    writer = nil
    video = nil
    audio = nil
    url = nil
    started = false
  }
}
