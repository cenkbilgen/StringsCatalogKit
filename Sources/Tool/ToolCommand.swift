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
struct ToolCommand: AsyncParsableCommand {
    static let version = "1.1.0"
    
    static let configuration = CommandConfiguration(
        commandName: "strings_catalog_tool",
        abstract: "A utility for examining and working with Xcode Strings Catalog files. \(isDEBUG ? "(DEBUG BUILD)" : "")",
        version: version,
        subcommands: [
            ListKeys.self,
            ListLanguages.self,
            RemoveLanuage.self
        ]
    )

    #if DEBUG
    static let isDEBUG = true
    #else
    static let isDEBUG = false
    #endif
    
    protocol ListCommand: AsyncParsableCommand {
        associatedtype List: Collection<String>
        var listGenerator: (StringsCatalog) -> List { get }
        var fileOptions: FileOptions { get }
        var commaSeperated: Bool { get }
    }
    
    struct ListKeys: ListCommand {
        static let configuration = CommandConfiguration(
            commandName: "list_keys",
            abstract: "List base language keys."
        )
        
        @OptionGroup var fileOptions: FileOptions
        @Flag(name: .shortAndLong) var commaSeperated = false
        var listGenerator: (StringsCatalog) -> Set<String> {
            {
                $0.getKeys()
            }
        }
    }
    
    struct ListLanguages: ListCommand {
        static let configuration = CommandConfiguration(
            commandName: "list_languages",
            abstract: "List all languages in catalog."
        )
        
        @OptionGroup var fileOptions: FileOptions
        @Flag(name: .shortAndLong) var commaSeperated = false
        // @Flag(name: .long: "Show count of keys translated.") var count = false
        var count: Bool { false }
        
        var listGenerator: (StringsCatalog) -> [String] {
            {
                $0.getLanguages()
                    .map {
                        count ? "\($0.key) [\($0.value.formatted())]" : $0.key
                    }
            }
        }
    }
    
    struct RemoveLanuage: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "remove_language",
            abstract: "Remove all translations for a language."
        )
        
        @OptionGroup var fileOptions: FileOptions
        
        @Argument var languageCode: String
        
        func run() async throws {
            let url = URL.init(filePath: fileOptions.file, directoryHint: .notDirectory)
            let catalog = try StringsCatalog.read(url: url)
            try catalog.removeLanguage(code: languageCode)
            let data = try catalog.output()
            try data.write(to: url)
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

extension ToolCommand.ListCommand {
    func run() async throws {
        let url = URL.init(filePath: fileOptions.file, directoryHint: .notDirectory)
        let catalog = try StringsCatalog.read(url: url)
        let formattedOutput = listGenerator(catalog)
            .map { value in
                "\"\(value)\""
            }
            .joined(separator: commaSeperated ? ",\n" : "\n")
        print(formattedOutput)
    }
}
