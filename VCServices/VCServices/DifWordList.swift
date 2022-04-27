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
            self.words = content.components(separatedBy: .whitespacesAndNewlines).filter{ !($0.isEmpty) }
        } else {
            return nil
        }
    }

    /// Selects a word at random from the list and returns it
    public func randomWord() -> String {
        let index = arc4random_uniform(UInt32(self.words.count))
        return self.words[Int(index)]
    }

    public func generatePassword() -> String {

        var list = [String]()
        var set = Set<String>()
        
        repeat {
            // Get another word
            let word = self.randomWord()
            
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
