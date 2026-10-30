import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") apply false
    id("com.google.firebase.crashlytics") apply false
}

// Firebase, for push notifications and crash reports, only when its config
// is there. google-services.json is kept out of the repository: CI writes it
// from the GOOGLE_SERVICES_JSON secret, and a build without it — a local one,
// or the paywall test build — simply has neither. The Google services plugin
// fails the build outright when the file is missing, so it cannot be applied
// unconditionally; Crashlytics needs the build id its plugin stamps in, or the
// app would die on launch the moment Firebase starts.
if (file("google-services.json").exists()) {
    apply(plugin = "com.google.gms.google-services")
    apply(plugin = "com.google.firebase.crashlytics")
}

// The upload key, kept out of the repository. android/key.properties names the
// keystore and its passwords; see docs/building.md. Without it a release build
// is signed with the debug key, which runs on a phone but which Google Play
// refuses.
val keyProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}
val hasUploadKey = keyProperties.getProperty("storeFile") != null

android {
    namespace = "com.outrepd.outrepd"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // flutter_local_notifications schedules the daily reminder with
        // java.time, which older Androids only have through desugaring.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.outrepd.outrepd"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // Health Connect, which the health plugin needs, starts at Android 8.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["appLabel"] = "outrepd"
        // AdMob (lib/ads.dart): this app's own id from the build's
        // ADMOB_ANDROID_APP_ID, or Google's sample one — without any id the
        // ads SDK stops the app at launch.
        manifestPlaceholders["admobAppId"] =
            System.getenv("ADMOB_ANDROID_APP_ID")?.takeIf { it.isNotBlank() }
                ?: "ca-app-pub-3940256099942544~3347511713"
    }

    signingConfigs {
        if (hasUploadKey) {
            create("release") {
                storeFile = file(keyProperties.getProperty("storeFile"))
                storePassword = keyProperties.getProperty("storePassword")
                keyAlias = keyProperties.getProperty("keyAlias")
                keyPassword = keyProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        // A debug build is the paywall test build: it carries RevenueCat's Test
        // Store key, which crashes a release build on purpose. Its own id and
        // name let it sit beside the real app instead of fighting its
        // signature, and make it obvious which one is open.
        debug {
            applicationIdSuffix = ".test"
            manifestPlaceholders["appLabel"] = "outrepd test"
        }

        release {
            signingConfig =
                if (hasUploadKey) signingConfigs.getByName("release")
                else signingConfigs.getByName("debug")

            // On, because Google Play marks an app whose code is not shrunk and
            // obfuscated (2026-10-30: "Obfuscation 1%" on 1.1.5). It was off
            // after ML Kit's WorkManager lost a class looked up by name and the
            // app died before its first frame; proguard-rules.pro keeps that
            // and the other classes found by name, and CI's launch-check opens
            // the release APK on an emulator so a crash like that fails the run.
            // The mapping travels inside the App Bundle for Play, and to
            // Crashlytics, so crash reports still read.
            isMinifyEnabled = true
            // Resources stay: some are looked up by name from Dart (the
            // notification icon), which the resource shrinker cannot see.
            isShrinkResources = false

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
