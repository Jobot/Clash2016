//
//  Messenger.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 4/1/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import Foundation

struct Messenger {
    
    let state: GameState
    
    func randomMessageFromMessages(messages: [String]) -> String {
        let index = random() % messages.count
        return messages[index]
    }
    
    func messageForUnknownText(text: String) -> String {
        let messages = [ "I do not understand.",
                         "I don't know what you mean.",
                         "I don't follow."
        ]
        return randomMessageFromMessages(messages)
    }
    
    func messageForExamineItem(item: InventoryItem) -> String {
        if (state.location.region == .MostlyEmptyRoom) && !state.flashlightIsOn {
            return "It's too dark for that."
        }
        
        if state.inventory.contains(item) {
            return item.describe()
        }
        
        if state.location.inventory.contains(item) {
            return item.describe()
        }
        
        let messages = [ "You do not see \(item) here.",
                         "I don't see \(item). Do you see \(item)?",
                         "\(item) is not here."
        ]
        return randomMessageFromMessages(messages)
    }
    
    func messageForTakeItem(item: InventoryItem) -> String {
        if (state.location.region == .MostlyEmptyRoom) && !state.flashlightIsOn {
            return "It's too dark for that."
        }
        
        if !item.canTake() {
            return "That's not something you can take."
        }
        
        if state.inventory.contains(item) {
            return "You already have \(item)."
        }
        if state.location.inventory.contains(item) {
            if let index = state.location.inventory.indexOf(item) {
                state.location.inventory.removeAtIndex(index)
                state.inventory.append(item)
                return "You take \(item)."
            }
        }
        
        let messages = [ "You cannot take \(item).",
                         "Why do you want to take \(item)?",
                         "That's not yours.",
                         "That's not something you can take."
        ]
        return randomMessageFromMessages(messages)
    }
    
    func messageForOpenItem(item: InventoryItem) -> String {
        if (state.location.region == .MostlyEmptyRoom) && !state.flashlightIsOn {
            return "It's too dark for that."
        }
        
        let messages = [ "It does not seem to open.",
                         "Not everything can be opened.",
                         "You cannot open \(item) right now."
        ]
        return randomMessageFromMessages(messages)
    }
    
    func messageForInventory() -> String {
        let emptyMessages = [ "You have nothing in your inventory.",
                              "Sadly, you're pockets are empty.",
                              "You have nothing to your name.",
                              "There are no items in your inventory.",
                              "Your inventory is empty."
        ]
        let fullMessages = [ "Your inventory contains:",
                             "You have in your inventory:",
                             "You currently possess:",
                             "You are the proud owner of:"
        ]
        if state.inventory.count < 1 {
            return randomMessageFromMessages(emptyMessages)
        } else {
            return state.inventory.reduce(randomMessageFromMessages(fullMessages)) { (message, item) -> String in
                return "\(message)\n\t\(item.rawValue)"
            }
        }
    }
    
    func messageForTurnOnItem(item: InventoryItem) -> String {
        if state.inventory.contains(item) {
            // user has item ... can we turn it on?
            if item == .Flashlight {
                if state.flashlightIsOn {
                    return "Your flashlight is already on."
                } else {
                    state.flashlightIsOn = true
                    return "You turn on your flashlight."
                }
            }
        }
        
        let messages = [
            "That doesn't seem to work.",
            "You don't know how to turn that on.",
            "That cannot be turned on."
        ]
        return randomMessageFromMessages(messages)
    }
    
    func messageForTurnOffItem(item: InventoryItem) -> String {
        if state.inventory.contains(item) {
            // user has the item .. can we turn it off?
            if item == .Flashlight {
                if state.flashlightIsOn {
                    state.flashlightIsOn = false
                    return "You turn off your flashlight."
                } else {
                    return "Your flashlight is not on."
                }
            }
        }
        
        let messages = [
            "That doesn't seem to work.",
            "You don't know how to turn that off.",
            "That cannot be turned off."
        ]
        return randomMessageFromMessages(messages)
    }
}
