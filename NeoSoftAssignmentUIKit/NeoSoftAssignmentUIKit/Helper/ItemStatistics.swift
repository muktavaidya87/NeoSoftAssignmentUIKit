//
//  Untitled.swift
//  NeoSoftAssignmentUIKit
//
//  Created by Mukta on 22/12/24.
//

class ItemStatistics {
    func calculateStatistics(for items: [Item]) -> (itemCount: Int, topChars: [(Character, Int)]) {
        let displayNames = items.map { $0.displayName }
        let characterCount: [Character: Int] = displayNames
            .flatMap { $0 } // Flatten all strings into characters
            .reduce(into: [:]) { counts, char in
                counts[char, default: 0] += 1
            }
        
        let sortedChars = characterCount
            .sorted { $0.value > $1.value }
        
        return (displayNames.count, Array(sortedChars.prefix(3)))
    }
}
