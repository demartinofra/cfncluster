plugins {
    java
    id("software.amazon.smithy").version("0.5.1")
}

repositories {
    mavenLocal()
    mavenCentral()
}

buildscript {
    dependencies {
        classpath("software.amazon.smithy:smithy-openapi:1.5.1")
        classpath("software.amazon.smithy:smithy-aws-traits:1.5.1")
        classpath("software.amazon.smithy:smithy-aws-apigateway-openapi:1.5.1")
    }
}

dependencies {
    implementation("software.amazon.smithy:smithy-aws-apigateway-traits:1.5.1")
    implementation("software.amazon.smithy:smithy-aws-traits:1.5.1")
    implementation("software.amazon.smithy:smithy-model:1.5.1")
    implementation("software.amazon.smithy:smithy-linters:1.5.1")
}

tasks["jar"].enabled = false
