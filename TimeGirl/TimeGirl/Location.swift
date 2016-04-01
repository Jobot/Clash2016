//
//  Location.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 3/31/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import Cocoa

enum Region {
    case Pompeii
    case Troy
    
    func gemColor() -> NSColor {
        switch self {
        case .Pompeii:
            return NSColor.redColor()
        case .Troy:
            return NSColor.orangeColor()
        }
    }
    
    func locations() -> [Location] {
        switch self {
        case .Pompeii:
            return [
                Location(name: "The town of Pompeii", region: self, inventory: []),
                Location(name: "Inside the Volcano", region: self, inventory: [ "An orange gem" ])
            ]
        case .Troy:
            return [
                Location(name: "The wall of Troy", region: self, inventory: [ ]),
                Location(name: "The town of Troy", region: self, inventory: [ ])
            ]
        }
    }
}

struct Location {
    let name: String
    let region: Region
    var inventory: [String]
}
