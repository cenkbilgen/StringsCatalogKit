# Strings Catalog Tool

`strings_catalog_tool` is a command-line utility designed to help examine and manipulate Xcode Strings Catalog files. This tool includes functions Xcode 16 doesn't currently have, including listing language keys, listing all language codes, and removing translations for a specified language from the catalog.

## Features

- **List Keys**: Display all base language keys in the strings catalog.
- **List Languages**: Display all available languages in the catalog.
- **Remove Language**: Remove all translations for a specified language.

## Installation

## Building

1. Clone the repository 
1. Run `swift build -c release` to build the `strings_catalog_tool` executable in `./.build/release`.
2. Copy the executable to a location in your `$PATH` for easy access.

## Usage

Below are detailed instructions on how to use each of the available commands:

### List Keys

```bash
strings_catalog_tool list_keys
```

- **Options**:
  - `-f`, `--file`: Specify the input Strings Catalog file. Defaults to `Localizable.xcstrings`.
  - `-c`, `--comma-separated`: Output keys as comma-separated values.

### List Languages

List all available languages in your Strings Catalog file.

```bash
strings_catalog_tool list_languages
```

- **Options**:
  - `-f`, `--file`: Specify the input Strings Catalog file. Defaults to `Localizable.xcstrings`.
  - `-c`, `--comma-separated`: Output languages as comma-separated values.
  - `count`: (Planned feature) Display the count of keys translated for each language.

### Remove Language

Remove all translations for a specified language code.

```bash
strings_catalog_tool remove_language --file Path/To/Your/Localizable.xcstrings LANGUAGE_CODE
```

## Library
Includes a target for StringsCatalogKit, the library used by this tool and [translate_strings](https://github.com/cenkbilgen/translate_strings). 
Targets:

  - **Library:** `StringsCatalogKit`
    - Offers a set of APIs to efficiently manage localization strings.
    - Compatible with macOS version 15 and above.
    
  - **Executable:** `strings_catalog_tool`
    - A command-line tool that leverages `StringsCatalogKit` for handling string operations.
