plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.BusyBee"
    compileSdk = 35 //flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"
    
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.BusyBee"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
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
    // Add this line for desugaring support!
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    // implementation("androidx.window:window:1.0.0")
    // implementation("androidx.window:window-java:1.0.0")
}
