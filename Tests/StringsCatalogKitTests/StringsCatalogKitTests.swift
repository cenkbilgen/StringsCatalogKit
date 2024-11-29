import Testing
import Foundation
@testable import StringsCatalogKit

enum TestData {
    static let base: URL = url(catalogName: "LocalizableBase")
    
    private static func url(catalogName: String) -> URL {
        if let url = Bundle.module.url(forResource: catalogName, withExtension: "xcstrings") {
            url
        } else {
            fatalError("Test data unavailable.")
        }
    }
}

@Test func decoding() async throws {
    print("Using \(TestData.base.lastPathComponent)")
    let catalog = try StringsCatalog.read(url: TestData.base)
    #expect(catalog.sourceLanguage == "en")
    #expect(catalog.strings.count == 141)
}

@Test func entry() async throws {
    print("Using \(TestData.base.lastPathComponent)")
    let catalog = try StringsCatalog.read(url: TestData.base)
    print(catalog.strings.keys)
    print(catalog.strings.values)
    let value = try catalog.getTranslation(key: "baseball", language: Locale.Language(identifier: "en").minimalIdentifier)
    #expect(value == "baseball")
}
