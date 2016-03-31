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
    case Open
    
    private static let examineStrings = [ "examine", "look at", "view", "inspect" ]
    private static let takeStrings = [ "take", "pick up", "grab", "snatch" ]
    private static let openStrings = [ "open" ]
    
    static func commandFromText(rawText: String) -> (command: Command?, remainingText: String) {
        let text = rawText.lowercaseString
        
        let examine = text.beginsWithPrefixInList(examineStrings)
        if examine.hasPrefix {
            let remainingText = self.remainingText(rawText, forPrefix: examine.prefix!)
            return (.Examine, remainingText)
        }
        
        let take = text.beginsWithPrefixInList(takeStrings)
        if take.hasPrefix {
            let remainingText = self.remainingText(rawText, forPrefix: take.prefix!)
            return (.Take, remainingText)
        }
        
        let open = text.beginsWithPrefixInList(openStrings)
        if open.hasPrefix {
            let remainingText = self.remainingText(rawText, forPrefix: open.prefix!)
            return (.Open, remainingText)
        }
        
        return (nil, rawText)
    }
    
    private static func remainingText(text: String, forPrefix prefix: String) -> String {
        let index = text.startIndex.advancedBy(prefix.characters.count + 1)
        return text.substringFromIndex(index)
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