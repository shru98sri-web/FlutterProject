android {
    namespace = "com.example.basic_ai_app"

    // 1. Force the compilation SDK version to 34
    compileSdk = 34
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.example.basic_ai_app"
        minSdk = flutter.minSdkVersion

        // 2. Force the target SDK version to 34
        targetSdk = 34

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}
