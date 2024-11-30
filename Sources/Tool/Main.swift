//
//  Main.swift
//  StringsCatalogKit
//
//  Created by Cenk Bilgen on 2024-11-30.
//

import Foundation
import ArgumentParser
import StringsCatalogKit

@main
struct Main: AsyncParsableCommand {
    static let version = "1.0.0"
    
    static let configuration = CommandConfiguration(
        commandName: "strings_catalog_command",
        abstract: "A utility for examining and working with Xcode Strings Catalog files. \(isDEBUG ? "(DEBUG BUILD)" : "")",
        version: version,
        subcommands: [
            ListKeys.self
        ]
    )

    #if DEBUG
    static let isDEBUG = true
    #else
    static let isDEBUG = false
    #endif
    
    struct ListKeys: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "list_keys",
            abstract: "List base language keys. \(isDEBUG ? "(DEBUG BUILD)" : "")"
        )
        
        @OptionGroup var fileOptions: FileOptions
        @Flag(name: .shortAndLong) var commaSeperated = false
        
        func run() async throws {
            let url = URL.init(filePath: fileOptions.file, directoryHint: .notDirectory)
            let catalog = try StringsCatalog.read(url: url)
            let keys = catalog.getKeys()
            let formattedOutput = keys
                .map { key in
                    "\"\(key)\""
                }
                .joined(separator: commaSeperated ? ",\n" : "\n")
            print(formattedOutput)
        }
    }
    
}

struct LanguageOption: ParsableArguments {
    @Option(name: .shortAndLong,
            help: "Language, ie \"en\".")
    var language: String
}

struct FileOptions: ParsableArguments {
    //    @Flag(name: .shortAndLong, help: "Verbose output to STDOUT")
    //    var verbose: Bool = false
    
    @Option(name: .shortAndLong,
            help: "Input Strings Catalog file.",
            completion: .file(extensions: ["xcstrings"]))
    var file: String = "Localizable.xcstrings"
    
    @Option(name: .shortAndLong,
            help: "Output Strings Catalog file. Overwrites. Use \"-\" for STDOUT.",
            completion: .file(extensions: ["xcstrings"]))
    var outFile: String = "Localizable.xcstrings"
    
}
