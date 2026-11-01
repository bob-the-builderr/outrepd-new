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
// AppLovin MAX's plugin (lib/ads.dart) still compiles against Android 31, and
// the AndroidX libraries it brings in need 34 or later; it is compiled against
// 36 instead. Registered before anything is evaluated, which the next block
// starts, so it runs before the Android plugin reads the setting. By name and
// reflection: the Android plugin's classes are not on this script's
// classpath, and AGP 9 has a setter where AGP 8 had a method.
subprojects {
    if (name == "applovin_max") {
        afterEvaluate {
            val android = extensions.getByName("android")
            val setter = android.javaClass.methods.firstOrNull {
                it.name == "setCompileSdk" && it.parameterCount == 1
            }
            if (setter != null) {
                setter.invoke(android, 36)
            } else {
                android.javaClass
                    .getMethod("compileSdkVersion", Int::class.javaPrimitiveType)
                    .invoke(android, 36)
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
