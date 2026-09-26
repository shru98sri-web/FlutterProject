buildscript {
    ext.kotlin_version = '1.9.22'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:8.3.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.4.1'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Fixed Build Directory Mapping (Groovy Syntax)
rootProject.layout.buildDirectory.value(rootProject.layout.projectDirectory.dir("../../build"))

subprojects {
    project.layout.buildDirectory.value(rootProject.layout.buildDirectory.get().dir(project.name))
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete) {
    delete rootProject.layout.buildDirectory
}

// Forces all subproject plugins (like fluttertoast) to safety use SDK 34
subprojects {
    afterEvaluate { project ->
        if (project.hasProperty('android')) {
            project.android {
                if (compileSdkVersion < 34) {
                    compileSdkVersion 34
                }
            }
        }
    }
}
