//
//  DataFiles.swift
//  FishStore
//
//  Created by MAY 04 on 15/10/26.
//

import Foundation

// Reads and writes the .txt data files stored in the app's Documents folder
enum DataFiles {
    static let categoryFile = "category.txt"
    static let fishFile = "fish.txt"

    static var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static func url(for fileName: String) -> URL {
        documentsURL.appendingPathComponent(fileName)
    }

    // MARK: - Setup

    // First launch only: copy the file from the app bundle into Documents
    static func prepare(_ fileName: String) {
        let destination = url(for: fileName)
        guard !FileManager.default.fileExists(atPath: destination.path) else { return }

        let name = (fileName as NSString).deletingPathExtension
        let ext = (fileName as NSString).pathExtension

        guard let source = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("Missing \(fileName) in the app bundle. Check its Target Membership.")
            return
        }
        try? FileManager.default.copyItem(at: source, to: destination)
    }

    // Deletes the Documents copy and copies the original file again
    static func restoreFromBundle(_ fileName: String) {
        try? FileManager.default.removeItem(at: url(for: fileName))
        prepare(fileName)
    }

    // MARK: - Reading

    static func rawText(_ fileName: String) -> String {
        prepare(fileName)
        return (try? String(contentsOf: url(for: fileName), encoding: .utf8)) ?? "(file not found)"
    }

    // Returns the non-empty lines of a file
    static func readLines(_ fileName: String) -> [String] {
        rawText(fileName)
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    // Splits one line into fields: 1, "Halfmoon, Betta", 85000
    static func parseFields(_ line: String) -> [String] {
        var fields: [String] = []
        var current = ""
        var inQuotes = false
        let chars = Array(line)
        var i = 0

        while i < chars.count {
            let c = chars[i]
            if inQuotes {
                if c == "\"" {
                    if i + 1 < chars.count && chars[i + 1] == "\"" {
                        current.append("\"")   // "" inside quotes means one quote
                        i += 1
                    } else {
                        inQuotes = false
                    }
                } else {
                    current.append(c)
                }
            } else if c == "\"" {
                inQuotes = true
            } else if c == "," {
                fields.append(current.trimmingCharacters(in: .whitespaces))
                current = ""
            } else {
                current.append(c)
            }
            i += 1
        }
        fields.append(current.trimmingCharacters(in: .whitespaces))
        return fields
    }

    // MARK: - Writing

    // Wraps text in quotes so commas inside it do not break the line
    static func quote(_ text: String) -> String {
        let cleaned = text
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\"", with: "\"\"")
        return "\"\(cleaned)\""
    }

    // Adds one new line at the end of the file
    static func append(_ line: String, to fileName: String) {
        prepare(fileName)
        var text = (try? String(contentsOf: url(for: fileName), encoding: .utf8)) ?? ""
        if !text.isEmpty && !text.hasSuffix("\n") {
            text += "\n"
        }
        text += line + "\n"
        try? text.write(to: url(for: fileName), atomically: true, encoding: .utf8)
    }
}
