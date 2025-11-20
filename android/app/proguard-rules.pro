# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Google Play Core (Fix R8 errors)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Ignore missing Play Core classes
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# HTTP and JSON for OTP service
-keep class dart.** { *; }
-keep class io.flutter.plugins.** { *; }
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses

# HTTP package
-keep class io.flutter.plugins.urllauncher.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# Preserve all native method names and the names of their classes
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep JSON serialization
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# SharedPreferences
-keep class androidx.preference.** { *; }
-keep class * extends androidx.preference.PreferenceFragmentCompat { *; }