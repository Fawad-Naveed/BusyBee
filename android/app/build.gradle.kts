plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.busybee"
    compileSdk = flutter.compileSdkVersion
   //println("compileSdkVersion: $compileSdk")
    ndkVersion = "27.0.12077973"
    
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        //var isCoreLibraryDesugaringEnabled: Boolean
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        //iscoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.busybee"
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
}

flutter {
    source = "../.."
}

dependencies {
    // Add this line for desugaring support!
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
