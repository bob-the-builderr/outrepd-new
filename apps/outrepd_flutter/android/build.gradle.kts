allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Android builds throw several gigabytes of intermediates around, and the
// system drive on this machine has no room for them. OUTREPD_BUILD_DIR points
// them at a roomier disk; without it the build stays where Flutter puts it.
val outOfTree: String? = System.getenv("OUTREPD_BUILD_DIR")

val newBuildDir: Directory = if (outOfTree != null) {
    rootProject.layout.projectDirectory.dir(outOfTree)
} else {
    rootProject.layout.buildDirectory.dir("../../build").get()
}
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
