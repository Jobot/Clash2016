//
//  Inventory.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 4/1/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import Foundation

enum InventoryItem: String {
    case RedGem = "a red gem"
    case OrangeGem = "an orange gem"
    case Flashlight = "a flashlight"
    
    static let acceptableNames: [ InventoryItem:[String] ] = [
        .RedGem : [ "red gem", "a red gem", "the red gem" ],
        .OrangeGem : [ "orange gem", "a orange gem", "an orange gem", "the orange gem" ],
        .Flashlight: [ "flashlight", "a flashlight", "my flashlight", "the flashlight", "a small flashlight" ]
    ]
    
    init?(rawValue: String) {
        let value = rawValue.lowercaseString
        
        for item in InventoryItem.acceptableNames.keys {
            if let items = InventoryItem.acceptableNames[item] {
                if items.contains(value) {
                    self = item
                    return
                }
            }
        }
        
        return nil
    }
    
    func canTake() -> Bool {
        switch self {
        case .RedGem, .OrangeGem:
            return true
        case .Flashlight:
            return true
        }
    }
    
    static func InventoryFromTokens(tokens: [String]) -> (inventory: InventoryItem?, consumedTokens: [String], remainingTokens: [String]) {
        let string = String.stringFromTokens(tokens).lowercaseString
        for nameList in acceptableNames.values {
            for name in nameList {
                if string.hasPrefix(name) {
                    let inventory = InventoryItem(rawValue: name)
                    let consumedTokens = name.tokenize()
                    let remainingTokens = Array(tokens.dropFirst(name.tokenize().count))
                    return (inventory, consumedTokens, remainingTokens)
                }
            }
        }
        return (nil, [], tokens)
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
