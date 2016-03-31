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
    
    static func commandFromText(text: String) -> (command: Command?, remainingText: String) {
        return (nil, text)
    }
}
