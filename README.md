# StringsCatalogKit & strings_catalog_tool

A tool to examine and modify the Xcode Strings Catalog files, providing additional functionality not all currently available in Xcode 16 or xcodebuild.

## Getting Started

`strings_catalog_tool` simplifies working with Xcode Strings Catalog files by offering features such as listing language keys, displaying all available languages, and removing translations for a specific language. 

### Example Usage

To list all base language keys in your Strings Catalog, call:

```shell
strings_catalog_tool list_keys
```

Ensure that the initial Strings Catalog file is added to your Xcode project. More details about Strings Catalogs can be found [here](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog).

By default, the tool operates on the `Localizable.xcstrings` file located in the path where the command is run.

### Usage

```
OVERVIEW: A utility for examining and manipulating Xcode Strings Catalogs.

USAGE: strings_catalog_tool <subcommand>

OPTIONS:
  --version               Show the version.
  -h, --help              Show help information.

SUBCOMMANDS:
  list_keys               List all base language keys in the strings catalog.
  list_languages          Display all available languages in the catalog.
  remove_language         Remove all translations for a specified language code.

  See 'strings_catalog_tool help <subcommand>' for detailed help.
```

## Building

1. Run `swift build -c release` to build the `strings_catalog_tool` executable in `./.build/release`.
2. Copy the executable to a location in your `$PATH` for easy access.

## Package Targets

This package includes two targets:
1. `strings_catalog_tool`: The command-line utility.
2. `StringsCatalogKit`: A library shared with other tools like [`translate_strings`](https://github.com/cenkbilgen/translate_strings).
