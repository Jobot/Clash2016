//
//  Inventory.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 4/1/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import Cocoa

enum InventoryItem: String {
    case RedGem = "a red gem"
    case OrangeGem = "an orange gem"
    case Flashlight = "a flashlight"
    case Door = "an ordinary door"
    case TimeMachine = "a strange machine"
    case DistantVolcano = "a distant volcano"
    case Evangeline = "Evangeline"
    
    static let acceptableNames: [ InventoryItem:[String] ] = [
        .RedGem : [ "ruby", "the ruby", "a ruby", "red gem", "a red gem", "the red gem", "big red gem", "a big red gem", "the big red gem" ],
        .OrangeGem : [ "orange gem", "a orange gem", "an orange gem", "the orange gem" ],
        .Flashlight: [ "flashlight", "a flashlight", "my flashlight", "the flashlight", "small flashlight", "a small flashlight", "my small flashlight", "the small flashlight" ],
        .Door : [ "door", "a door", "the door", "ordinary door", "an ordinary door", "the ordinary door" ],
        .TimeMachine: [ "machine", "a machine", "the machine", "strange machine", "a strange machine", "the strange machine", "time machine", "a time machine", "the time machine" ],
        .DistantVolcano: [ "distant volcano", "a distant volcano", "the distant volcano", "volcano", "a volcano", "the volcano" ],
        .Evangeline: [ "evangeline", "strange girl", "a strange girl", "the strange girl", "girl", "a girl", "the girl" ]
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
        case .Door:
            return false
        case .TimeMachine:
            return false
        case .DistantVolcano:
            return false
        case .Evangeline:
            return true
        }
    }
    
    func canUseWithItem(item: InventoryItem) -> Bool {
        switch self {
        case .RedGem, .OrangeGem:
            return item == .TimeMachine
        default:
            return false
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
        case .Door:
            return "An ordinary door. There's nothing special about it. It feels slightly warm."
        case .TimeMachine:
            return "A strange, star-shaped machine."
        case .DistantVolcano:
            return "A distant volcano. You see a thin trail of smoke rising from the top of the cone. It's probably harmless."
        case .Evangeline:
            return "A strange girl. You can't say exactly what's strange about her. She looks and is dressed much like the other locals. But something is different."
        }
    }
}
