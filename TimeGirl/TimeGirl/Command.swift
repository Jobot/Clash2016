//
//  Command.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 3/30/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import Foundation

enum Command {
    case Examine
    case Take
    
    static let examineStrings = [ "examine", "look at", "view", "inspect" ]
    static let takeStrings = [ "take", "pick up", "grab", "snatch" ]
    
    static func commandFromText(rawText: String) -> (command: Command?, remainingText: String) {
        let text = rawText.lowercaseString
        
        let examine = text.beginsWithPrefixInList(examineStrings)
        if examine.hasPrefix {
            let prefix = examine.prefix!
            let index = rawText.startIndex.advancedBy(prefix.characters.count + 1)
            let remainingText = rawText.substringFromIndex(index)
            return (.Examine, remainingText)
        }
        
        let take = text.beginsWithPrefixInList(takeStrings)
        if take.hasPrefix {
            let prefix = take.prefix!
            let index = rawText.startIndex.advancedBy(prefix.characters.count + 1)
            let remainingText = rawText.substringFromIndex(index)
            return (.Take, remainingText)
        }
        
        return (nil, rawText)
    }
}

extension String {
    func beginsWithPrefixInList(prefixes: [String]) -> (hasPrefix: Bool, prefix: String?) {
        for prefix in prefixes {
            if self.hasPrefix("\(prefix) ") {
                return (true, prefix)
            }
        }
        return (false, nil)
    }
}