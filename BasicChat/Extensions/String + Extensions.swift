//
//  String + Extensions.swift
//  BasicChat
//
//  Created by Julian Boxnick on 25.09.22.
//

import Foundation

extension String {
    
    var isInt: Bool {
        return Int(self) != nil
    }
        
    func firstCharacterUpperCase() -> String? {
        guard !isEmpty else { return nil }
        let lowerCasedString = self.lowercased()
        return lowerCasedString.replacingCharacters(in: lowerCasedString.startIndex...lowerCasedString.startIndex, with: String(lowerCasedString[lowerCasedString.startIndex]).uppercased())
    }
    
    func lowerCasedAndWithoutWhitespaces() -> String? {
        guard !isEmpty else { return nil }
        let lowerCasedString = self.lowercased()
        let removeMinus = lowerCasedString.replacingOccurrences(of: "-", with: "")
        let withoutWhiteSpaces = removeMinus.replacingOccurrences(of: " ", with: "")
        return withoutWhiteSpaces
        }
}

extension StringProtocol {
    
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
    }
}
