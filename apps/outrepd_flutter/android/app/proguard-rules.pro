# ML Kit loads its detectors and its bundled pose model by reflection, so the
# shrinker cannot see those classes being used and strips them. The app then
# dies while registering plugins — before any of our code runs, which makes it
# look like the app simply will not open.
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_** { *; }
-dontwarn com.google.mlkit.**

# The vision libraries reference optional Play Services pieces that are not
# always present. Missing ones are handled at runtime; the warnings are noise.
-dontwarn com.google.android.gms.**

# ML Kit drags in WorkManager, and WorkManager builds its Room database by
# looking up a generated class by name. Rename it and the app dies during
# content-provider startup, before any of our code runs — which reads on the
# phone as "the app will not open". This was the actual crash.
-keep class * extends androidx.room.RoomDatabase { *; }
-keep class androidx.work.impl.** { *; }
-keep class androidx.startup.** { *; }
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

# Our own few classes (MainActivity, the home-screen widgets) are found by name
# from the manifest and from Dart's home_widget calls.
-keep class com.outrepd.outrepd.** { *; }

# Crash reports keep their file and line numbers, mapped back by the mapping.
-keepattributes SourceFile, LineNumberTable
-renamesourcefileattribute SourceFile
