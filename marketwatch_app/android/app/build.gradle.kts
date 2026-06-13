plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.marketwatch_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    defaultConfig {
        applicationId = "com.example.marketwatch_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // ─── TFLite: prevent AAPT from compressing the model file ───────
    // Place this inside the android { } block.
    // Without this, the APK packs the .tflite file as a compressed
    // asset, which corrupts it and causes the interpreter to crash.
    aaptOptions {
        noCompress += "tflite"
    }
    // ─────────────────────────────────────────────────────────────────
}

kotlin {
    compilerOptions {
        // Must match compileOptions above to avoid the
        // "Inconsistent JVM-target compatibility" build error.
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11
    }
}

flutter {
    source = "../.."
}
