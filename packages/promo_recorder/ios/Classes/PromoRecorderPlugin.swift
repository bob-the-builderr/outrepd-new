import AVFoundation
import CoreImage
import Flutter
import Photos
import ReplayKit
import UIKit

/// The app's own frames from ReplayKit, written as HEVC at the screen's full
/// resolution and a high bitrate, with the app's sound, then saved to Photos.
/// Given an aspect ratio, only the band of that shape across the middle of
/// the screen is kept — the app draws the take inside it.
public class PromoRecorderPlugin: NSObject, FlutterPlugin {
  private let queue = DispatchQueue(label: "outrepd.promo.recorder")
  private let context = CIContext(options: [.cacheIntermediates: false])
  private var writer: AVAssetWriter?
  private var video: AVAssetWriterInput?
  private var audio: AVAssetWriterInput?
  private var adaptor: AVAssetWriterInputPixelBufferAdaptor?
  private var crop: CGRect?
  private var aspect: Double?
  private var url: URL?
  private var started = false
  private var failed = false

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "outrepd/promo_recorder", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(PromoRecorderPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "start":
      let aspect = (call.arguments as? [String: Any])?["aspect"] as? Double
      start(aspect: aspect, result)
    case "stop": stop(result)
    default: result(FlutterMethodNotImplemented)
    }
  }

  private func start(aspect: Double?, _ result: @escaping FlutterResult) {
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

    let url = FileManager.default.temporaryDirectory
      .appendingPathComponent("outrepd-take-\(Int(Date().timeIntervalSince1970)).mp4")
    try? FileManager.default.removeItem(at: url)
    queue.sync {
      self.reset()
      self.url = url
      self.aspect = aspect
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

  /// The writer is made on the first picture, sized from it: what ReplayKit
  /// hands over is what gets kept, never a guess at the screen.
  private func open(on pixels: CVPixelBuffer, at time: CMTime) -> Bool {
    guard let url = url else { return false }
    let sourceWidth = CVPixelBufferGetWidth(pixels)
    let sourceHeight = CVPixelBufferGetHeight(pixels)
    // Whole pairs of pixels: the encoder takes nothing else.
    let width = sourceWidth / 2 * 2
    var height = sourceHeight / 2 * 2
    if let aspect = aspect, aspect > 0 {
      let band = Int((Double(width) / aspect).rounded()) / 2 * 2
      if band < height {
        height = band
        let top = Double(sourceHeight - band) / 2
        crop = CGRect(x: 0, y: top, width: Double(width), height: Double(band))
      }
    }

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
      let adaptor = AVAssetWriterInputPixelBufferAdaptor(
        assetWriterInput: video,
        sourcePixelBufferAttributes: [
          kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
          kCVPixelBufferWidthKey as String: width,
          kCVPixelBufferHeightKey as String: height,
        ])
      let audio = AVAssetWriterInput(mediaType: .audio, outputSettings: [
        AVFormatIDKey: kAudioFormatMPEG4AAC,
        AVNumberOfChannelsKey: 2,
        AVSampleRateKey: 44_100,
        AVEncoderBitRateKey: 192_000,
      ])
      audio.expectsMediaDataInRealTime = true
      if writer.canAdd(video) { writer.add(video) }
      if writer.canAdd(audio) { writer.add(audio) }
      guard writer.startWriting() else { return false }
      writer.startSession(atSourceTime: time)
      self.writer = writer
      self.video = video
      self.audio = audio
      self.adaptor = adaptor
      return true
    } catch {
      return false
    }
  }

  private func append(_ buffer: CMSampleBuffer, _ type: RPSampleBufferType) {
    guard !failed, CMSampleBufferDataIsReady(buffer) else { return }
    let time = CMSampleBufferGetPresentationTimeStamp(buffer)
    if !started {
      // The film starts on a picture, never on sound.
      guard type == .video, let pixels = CMSampleBufferGetImageBuffer(buffer) else { return }
      guard open(on: pixels, at: time) else {
        failed = true
        return
      }
      started = true
    }
    guard let writer = writer, writer.status == .writing else { return }
    switch type {
    case .video:
      guard let video = video, video.isReadyForMoreMediaData,
            let pixels = CMSampleBufferGetImageBuffer(buffer) else { return }
      if let crop = crop, let adaptor = adaptor, let pool = adaptor.pixelBufferPool {
        var out: CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(nil, pool, &out)
        guard let out = out else { return }
        let image = CIImage(cvPixelBuffer: pixels)
          .cropped(to: crop)
          .transformed(by: CGAffineTransform(translationX: -crop.minX, y: -crop.minY))
        context.render(image, to: out)
        adaptor.append(out, withPresentationTime: time)
      } else {
        video.append(buffer)
      }
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
    adaptor = nil
    crop = nil
    aspect = nil
    url = nil
    started = false
    failed = false
  }
}
