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
    
    func messageForExamineItem(item: String) -> String {
        if let knownItem = Inventory(rawValue: item) {
            if state.inventory.contains(knownItem) {
                return knownItem.describe()
            }
        }
        
        let messages = [ "You do not see \(item) here.",
                         "I don't see \(item). Do you see \(item)?",
                         "\(item) is not here."
        ]
        return randomMessageFromMessages(messages)
    }
    
    func messageForTakeItem(item: String) -> String {
        let messages = [ "You cannot take \(item).",
                         "Why do you want to take \(item)?",
                         "That's not yours.",
                         "That's not something you can take."
        ]
        return randomMessageFromMessages(messages)
    }
    
    func messageForOpenItem(item: String) -> String {
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
}
