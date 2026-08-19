import org.jetbrains.kotlin.gradle.dsl.JvmTarget

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Universal fallback to force Java 11 / JVM 11 targets everywhere across all modules
subprojects {
    afterEvaluate {
        // Enforce Java 11 compilation compatibility on any subproject using the Android plugin
        if (project.plugins.hasPlugin("com.android.application") || project.plugins.hasPlugin("com.android.library")) {
            // Directly set compatibility configurations via project property pathways to avoid type-mismatch bugs
            project.setProperty("android.compileOptions.sourceCompatibility", JavaVersion.VERSION_11)
            project.setProperty("android.compileOptions.targetCompatibility", JavaVersion.VERSION_11)
        }

        // Force all Kotlin compilation tasks across your third-party packages to target JVM 11
        project.tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            compilerOptions {
                jvmTarget.set(JvmTarget.JVM_11)
            }
        }
    }
}
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

        allprojects {
            repositories {
                google()
                mavenCentral()
            }
        }

// Universal fallback to force Java 11 / JVM 11 targets everywhere across all modules
subprojects {
    afterEvaluate {
        // Enforce Java 11 compilation compatibility on any subproject using the Android plugin
        if (project.plugins.hasPlugin("com.android.application") || project.plugins.hasPlugin("com.android.library")) {
            // Directly set compatibility configurations via project property pathways to avoid type-mismatch bugs
            project.setProperty("android.compileOptions.sourceCompatibility", JavaVersion.VERSION_11)
            project.setProperty("android.compileOptions.targetCompatibility", JavaVersion.VERSION_11)
        }

        // Force all Kotlin compilation tasks across your third-party packages to target JVM 11
        project.tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            compilerOptions {
                jvmTarget.set(JvmTarget.JVM_11)
            }
        }
    }
}
