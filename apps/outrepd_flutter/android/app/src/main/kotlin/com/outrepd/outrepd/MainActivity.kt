package com.outrepd.outrepd

import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// A FragmentActivity: Health Connect's permission screen is opened with
// registerForActivityResult, which a plain FlutterActivity does not have.
class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Edge to edge on every Android version, the way Android 15 and later
        // already draw an app that targets SDK 35 (Google Play asks for it):
        // the app runs under the status and navigation bars, and Flutter's
        // MediaQuery padding keeps its content clear of them. After Flutter's
        // own onCreate, so its translucent status bar does not stay on older
        // phones and they look the same as Android 15.
        enableEdgeToEdge()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // CI opens the release APK with this extra to have it run ML Kit once
        // (lib/launch_self_test.dart, .github/scripts/launch_check.sh); a
        // normal launch answers false and nothing happens.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "outrepd/launch")
            .setMethodCallHandler { call, result ->
                if (call.method == "selfTest") {
                    result.success(intent?.getBooleanExtra(SELF_TEST, false) == true)
                } else {
                    result.notImplemented()
                }
            }
    }

    private companion object {
        const val SELF_TEST = "outrepd.selftest"
    }
}
