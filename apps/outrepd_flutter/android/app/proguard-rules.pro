# ML Kit carries its own rules for what it finds by name (its JNI classes, its
# protobuf fields, anything marked @UsedByNative / @UsedByReflection), so it is
# shrunk and renamed like the rest: keeping all of it whole was 2,400 classes,
# a quarter of everything R8 left untouched (Play: 47% optimised, 1.1.7 build
# 340). Its components are found by name from the manifest. CI's launch check
# runs the pose detector in the release APK (lib/launch_self_test.dart), so a
# class ML Kit needs and R8 took out fails the run.
-keep class * implements com.google.firebase.components.ComponentRegistrar { <init>(); }
-keepclasseswithmembernames,includedescriptorclasses class * { native <methods>; }
-dontwarn com.google.mlkit.**

# The vision libraries reference optional Play Services pieces that are not
# always present. Missing ones are handled at runtime; the warnings are noise.
-dontwarn com.google.android.gms.**

# ML Kit drags in WorkManager, and WorkManager builds its Room database by
# looking up a generated class by name. Rename it and the app dies during
# content-provider startup, before any of our code runs — which reads on the
# phone as "the app will not open". This was the actual crash. Only the
# database class itself is kept whole: WorkManager's own rules keep its
# workers and input mergers by name, and androidx.startup's keep the
# initialisers its provider reads from the manifest. All of androidx.work.impl
# (292 classes) is shrunk and renamed now; CI's launch check opens the release
# APK, which builds this database at startup.
-keep class * extends androidx.room.RoomDatabase { *; }
-keep class * extends androidx.startup.Initializer { <init>(); }
-dontwarn androidx.work.**

# Flutter's engine refers to Play Core for deferred components, which this app
# never uses; without this R8 stops the build on the missing classes.
-dontwarn com.google.android.play.core.**

# flutter_local_notifications keeps scheduled notifications as Gson JSON, and
# Gson reads generic types back through TypeToken's signature. Strip either and
# the daily reminder crashes when it is rescheduled.
-keep class com.dexterous.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keepattributes Signature, InnerClasses, EnclosingMethod, *Annotation*

# The health plugin is still linked, but Health Connect is no longer in the
# Android manifest: its references are expected to be unresolved.
-dontwarn androidx.health.**

# uCrop, the crop screen for a profile picture: its activity is found by name
# from the manifest, and its README asks for these.
-dontwarn com.yalantis.ucrop**
-keep class com.yalantis.ucrop** { *; }
-keep interface com.yalantis.ucrop** { *; }

# Our own few classes (MainActivity, the home-screen widgets) are found by name
# from the manifest and from Dart's home_widget calls.
-keep class com.outrepd.outrepd.** { *; }

# Crash reports keep their file and line numbers, mapped back by the mapping.
-keepattributes SourceFile, LineNumberTable
-renamesourcefileattribute SourceFile
