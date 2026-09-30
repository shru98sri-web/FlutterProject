allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    val cleanManifestAction = Action<Project> {
        extensions.findByName("android")?.let { androidExtension ->
            // Use pure Java reflection methods to dynamically modify compileSdk across AGP versions
            try {
                val method = androidExtension.javaClass.getMethod("setCompileSdk", java.lang.Integer::class.java)
                method.invoke(androidExtension, 37)
            } catch (e: Exception) {
                try {
                    val fallbackMethod = androidExtension.javaClass.getMethod("setCompileSdkVersion", java.lang.Integer.TYPE)
                    fallbackMethod.invoke(androidExtension, 37)
                } catch (ex: Exception) {
                    // Property modification omitted if the module isn't an Android plugin target
                }
            }

            // Strips out deprecated package syntax from cached packages
            val manifests = fileTree(mapOf("dir" to projectDir, "include" to listOf("**/AndroidManifest.xml")))
            manifests.forEach { manifestFile ->
                if (manifestFile.exists() && manifestFile.isFile) {
                    var content = manifestFile.readText(Charsets.UTF_8)
                    if (content.contains("package=")) {
                        println("Removing deprecated package attribute from: ${manifestFile.absolutePath}")
                        content = content.replace(Regex("""package="[^"]*""""), "")
                        manifestFile.writeText(content, Charsets.UTF_8)
                    }
                }
            }
        }
    }

    if (state.executed) {
        cleanManifestAction.execute(this)
    } else {
        afterEvaluate(cleanManifestAction)
    }
}
