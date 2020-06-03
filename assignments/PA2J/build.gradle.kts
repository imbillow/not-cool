import org.jetbrains.grammarkit.tasks.GenerateLexer

sourceSets {
    main {
        java.srcDir(".")
    }
}

tasks.register<GenerateLexer>("generateLexer") {
    val jlex = project.configurations.compileOnly.files
            .filter { it.name.startsWith("jflex") }
    classpath(jlex)

    // source flex file
    source = "cool.flex"

    // target directory for lexer
    targetDir = "./"

    // target classname, target file will be targetDir/targetClass.java
    targetClass = "CoolLexer"

    // optional, path to the task-specific skeleton file. Default: none
    // skeleton = "/some/specific/skeleton"

    // if set, plugin will remove a lexer output file before generating new one. Default: false
    purgeOldFiles = true
}
