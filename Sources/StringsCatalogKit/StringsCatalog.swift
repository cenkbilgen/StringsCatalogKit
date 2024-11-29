//
//  StringsCatalog.swift
//  translate_strings
//
//  Created by Cenk Bilgen on 2024-10-06.
//

import Foundation

public final class StringsCatalog: Codable {
    public let version: String
    public let sourceLanguage: String
    public var strings: [String: Entry]

    public struct Entry: Codable {
        public var shouldTranslate: Bool?
        public var localizations: [String: [String: Unit]]? // [language: ["stringUnit": unit]]
        public static let localizationsStringUnitKey = "stringUnit"
        public struct Unit: Codable {
            public var state: State
            public var value: String
        }
        public enum State: String, Codable {
            case new, translated
        }
    }

    public enum Error: Swift.Error, LocalizedError {
        case noEntry(String)
        case markedDoNotTranslate
        
        public var errorDescription: String? {
            switch self {
            case .noEntry(let entry):
                return String(format: NSLocalizedString("No entry found for '%@'.", comment: "No entry found error"), entry)
            case .markedDoNotTranslate:
                return NSLocalizedString("The text is marked as 'Do Not Translate'.", comment: "Do not translate error")
            }
        }
    }
}

extension StringsCatalog {

    public static func read(url: URL) throws -> StringsCatalog {
        try JSONDecoder().decode(
            StringsCatalog.self,
            from: try Data(contentsOf: url)
        )
    }

    public func output() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }
    
    // MARK: Languages
 
    /* NOTE: Not using Locale.Language.Code for langauges, just use String, because it is untyped JSON, the file could have language codes that don't map or are invalid */
    /* Such PO, which could inadvertently be used intenting to translate to Polish (which is should be PL in the BP417 standard) */

    public func getLanguages() -> [String: Int] { // [language code: entries translated count]
        strings.reduce(into: [String: Int]()) { result, entry in
            if let languages = entry.value.localizations?.keys {
                for language in languages {
                    result[language] = result[language, default: 0] + 1
                }
            }
        }
    }
    
    public func removeLanguage(code: String) {
        for string in strings {
            if string.value.hasLanuage(code: code) {
                var entry = string.value
                entry.removeLanguage(code: code)
                strings[string.key] = entry
            }
        }
    }
    
    // MARK: Entries
    
    public func getKeys() -> Set<String> {
        Set(strings.keys)
    }

    public func getTranslation(key: String, language: String) throws -> String? {
        guard let entry = strings[key] else {
            throw Error.noEntry(key)
        }
        if entry.shouldTranslate == false {
            return key
        } else if let unit = entry.localizations?[language.lowercased()]?[StringsCatalog.Entry.localizationsStringUnitKey] {
            return if unit.state == .translated {
                unit.value
            } else {
                nil
            }
        } else {
            return nil
        }
    }

    public func addTranslation(key: String, language: String, value: String) throws {
        guard let entry = strings[key] else {
            throw Error.noEntry(key)
        }
        guard entry.shouldTranslate != false else {
            throw Error.markedDoNotTranslate
        }
        let unit = Entry.Unit(state: .translated, value: value)
        if entry.localizations == nil {
            self.strings[key]?.localizations = [language.lowercased():
                                                    [StringsCatalog.Entry.localizationsStringUnitKey: unit]]
        } else {
            self.strings[key]?
                .localizations?[language.lowercased()] = [StringsCatalog.Entry.localizationsStringUnitKey: unit]
        }
    }
}

// MARK: StringsCatalog.Entry

extension StringsCatalog.Entry {
    func hasLanuage(code: String) -> Bool {
        localizations?.keys.contains(where: { languageCode in
            languageCode == code
        }) == true
    }
    
    mutating func removeLanguage(code: String) {
        localizations?.removeValue(forKey: code)
    }
}
