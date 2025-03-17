buildscript {
    repositories {
        google()  // ✅ Added this
        mavenCentral()  // ✅ Added this
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.0")  // ✅ Ensure latest Gradle version
        classpath("com.google.gms:google-services:4.3.15")  // ✅ Correct Kotlin syntax
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
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
