# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Alarm Manager
-keep class dev.fluttercommunity.plus.androidalarmmanager.** { *; }

# File Picker
-keep class com.mr.flutter.plugin.filepicker.** { *; }

# Permission Handler
-keep class com.baseflow.permissionhandler.** { *; }

# URL Launcher
-keep class io.flutter.plugins.urllauncher.** { *; }

# Keep R
-keep class **.R
-keep class *.R$ {
    *;
}

# Keep Parcelables
-keepclassmembers class * implements android.os.Parcelable {
    public static final ** CREATOR;
}