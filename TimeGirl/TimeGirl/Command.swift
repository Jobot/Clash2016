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
        
        if text.hasPrefix("examine ") {
            let index = rawText.startIndex.advancedBy(8)
            let remainingText = rawText.substringFromIndex(index)
            return (.Examine, remainingText)
        }
        
        return (nil, rawText)
    }
}
