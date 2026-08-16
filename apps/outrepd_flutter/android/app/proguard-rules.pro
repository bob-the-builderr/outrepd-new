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
