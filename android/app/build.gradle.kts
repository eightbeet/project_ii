plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.project_ii"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    // flutter.ndkVersion
    //
    // compileOptions {
    //     sourceCompatibility = JavaVersion.VERSION_1_8
    //     targetCompatibility = JavaVersion.VERSION_1_8
    // }
      
    lint {
       disable += "QueryAllPackagesPermission"
       disable += "BindAccessibilityServicePermission" 
    } 
    compileOptions {

        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    defaultConfig {

        manifestPlaceholders += mutableMapOf("QUERY_ALL_PACKAGES" to "true")
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.project_ii"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // minSdk = flutter.minSdkVersion
        minSdk = 26 
        targetSdk = 33
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    } 
}

dependencies {

   // implementation("com.google.code.gson:gson:2.10.1")
	implementation("com.google.android.material:material:1.4.0")
	// implementation("com.andrognito.pinlockview:pinlockview:2.1.0")
   coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}

configurations.all {
   resolutionStrategy {
      force("androidx.core:core-ktx:1.6.0")
   }
}
