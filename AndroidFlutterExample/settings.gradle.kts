pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
        maven { url = uri( "https://jitpack.io" )}
        maven {
            url = uri("/Users/cameron/rally/mobile/native_sdk_wrapper/build/host/outputs/repo")
        }
        maven {
            url= uri("https://storage.googleapis.com/download.flutter.io")
        }
    }
}

rootProject.name = "AndroidFlutterExample"
include(":app")
