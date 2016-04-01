//
//  Inventory.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 4/1/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import Foundation

enum Inventory: String {
    case RedGem = "a red gem"
    case OrangeGem = "an orange gem"
    case Flashlight = "a flashlight"
    
    static let acceptableNames: [ Inventory:[String] ] = [
        .RedGem : [ "red gem", "a red gem", "the red gem" ],
        .OrangeGem : [ "orange gem", "a orange gem", "an orange gem", "the orange gem" ],
        .Flashlight: [ "flashlight", "a flashlight", "my flashlight", "a small flashlight" ]
    ]
    
    init?(rawValue: String) {
        let value = rawValue.lowercaseString
        
        for item in Inventory.acceptableNames.keys {
            if let items = Inventory.acceptableNames[item] {
                if items.contains(value) {
                    self = item
                    return
                }
            }
        }
        
        return nil
    }
    
    func describe() -> String {
        switch self {
        case .RedGem:
            return "A large, shiny red gem. Despite its size the gem is surprisingly light."
        case .OrangeGem:
            return "A large orange gem. It's not very heavy. In fact, you could comfortably tote several of these in your backpack."
        case .Flashlight:
            return "A small, sturdy flashlight. This flashlight has accompanied you on many adventures, and you cannot imagine going anwhere without it."
        }
    }
}
