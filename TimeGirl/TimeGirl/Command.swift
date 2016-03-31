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
    
    static func commandFromText(rawText: String) -> (command: Command?, remainingText: String) {
        let text = rawText.lowercaseString
        
        let examine = text.beginsWithPrefixInList([ "examine", "look at" ])
        if examine.hasPrefix {
            let prefix = examine.prefix!
            let index = rawText.startIndex.advancedBy(prefix.characters.count + 1)
            let remainingText = rawText.substringFromIndex(index)
            return (.Examine, remainingText)
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