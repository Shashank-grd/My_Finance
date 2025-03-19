plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter Plugin
}

android {
    namespace = "com.example.myfinance"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true // ✅ Corrected Kotlin DSL syntax
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11" // ✅ Corrected Kotlin DSL syntax
    }

    defaultConfig {
        applicationId = "com.example.myfinance"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4") // ✅ Corrected Kotlin DSL syntax
}
