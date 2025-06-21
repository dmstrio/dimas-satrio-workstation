plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter plugin harus paling bawah
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.project_besar_mobile_programming"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // <- dipindahkan ke dalam blok yang sama

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.project_besar_mobile_programming"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false // <- diperbaiki agar tidak error saat build
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
