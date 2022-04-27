/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import Foundation

public class DifWordList {
    
    static let PasswordSeparator = " "

    let words: [String]
    
    public init?() throws {

        if let path = Bundle(for: Self.self).path(forResource: "difwordlist", ofType: "txt") {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            
            var sanitised = [String]()
            content.components(separatedBy: .newlines).forEach { component in
                let trimmed = component.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.isEmpty {
                    return
                }
                sanitised.append(trimmed)
            }
            self.words = sanitised
        } else {
            return nil
        }
    }

    public func generatePassword() -> String {

        var list = [String]()
        var set = Set<String>()
        
        repeat {
            // Pick the next word
            let index = arc4random_uniform(UInt32(self.words.count))
            let word = self.words[Int(index)]
            
            // Was it already selected?
            if set.contains(word) {
                continue
            }
            
            // Nope
            set.insert(word)
            list.append(word)
        } while (list.count < Constants.PasswordSetSize)

        return list.joined(separator: DifWordList.PasswordSeparator)
    }

    public static func normalize(password:String) -> String {

        var list = [String]()

        // Split the input string along whitespace, etc, and accumulate
        // each non-empty substring
        let components = password.components(separatedBy: .whitespacesAndNewlines)
        components.forEach { component in
            if component.isEmpty {
                return
            }
            list.append(component.lowercased())
        }
        
        return list.joined(separator: PasswordSeparator)
    }
}
