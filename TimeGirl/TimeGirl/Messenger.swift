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
    var knowsEvangeline = false
    
    init(state: GameState) {
        self.state = state
    }
    
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
    
    func messageForLookAround() -> String {
        return state.location.describeLocation()
    }
    
    func messageForExamineItem(item: InventoryItem) -> String {
        if (state.location.region == .MostlyEmptyRoom) && !state.flashlightIsOn {
            return "It's too dark for that."
        }
        
        if state.hasItemInInventory(item) {
            return item.describe()
        }
        
        if state.location.inventory.contains(item) {
            return item.describe()
        }
        
        if item == .Flashlight {
            // the user has already lost their flashlight ... make them feel sad
            return lostFlashlightMessage()
        }
        
        let messages = [ "You do not see \(item.rawValue) here.",
                         "I don't see \(item.rawValue). Do you see \(item.rawValue)?",
                         "\(item.rawValue) is not here."
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
        
        if state.hasItemInInventory(item) {
            return "You already have \(item.rawValue)."
        }
        if state.location.inventory.contains(item) {
            if let index = state.location.inventory.indexOf(item) {
                state.location.inventory.removeAtIndex(index)
                state.addItemToInventory(item)
                return "You take \(item.rawValue)."
            }
        }
        
        let messages = [ "You cannot take \(item.rawValue).",
                         "Why do you want to take \(item.rawValue)?",
                         "That's not yours.",
                         "That's not something you can take."
        ]
        return randomMessageFromMessages(messages)
    }
    
    func messageForOpenItem(item: InventoryItem) -> String {
        if (state.location.region == .MostlyEmptyRoom) && !state.flashlightIsOn {
            return "It's too dark for that."
        }
        
        if (item == .Door) && (state.location.region == .MostlyEmptyRoom) {
            return "The door will not open. Perhaps it's locked from the outside."
        }
        
        let messages = [ "It does not seem to open.",
                         "Not everything can be opened.",
                         "You cannot open \(item.rawValue) right now."
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
        if state.numberOfItemsInInventory() < 1 {
            return randomMessageFromMessages(emptyMessages)
        } else {
            return state.inventoryItems().reduce(randomMessageFromMessages(fullMessages)) { (message, item) -> String in
                return "\(message)\n\t\(item.rawValue)"
            }
        }
    }
    
    func messageForTurnOnItem(item: InventoryItem) -> String {
        if state.hasItemInInventory(item) {
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
        
        if item == .Flashlight {
            // the user has already lost their flashlight ... make them feel sad
            return lostFlashlightMessage()
        }
        
        if (state.location.region == .MostlyEmptyRoom) && !state.flashlightIsOn {
            return "It's too dark for that."
        }
        
        if (item == .TimeMachine) && state.location.inventory.contains(item) {
            return "The machine doesn't seem to have an on/off switch."
        }
        
        let messages = [
            "That doesn't seem to work.",
            "You don't know how to turn that on.",
            "That cannot be turned on."
        ]
        return randomMessageFromMessages(messages)
    }
    
    func messageForTurnOffItem(item: InventoryItem) -> String {
        if state.hasItemInInventory(item) {
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
        
        if item == .Flashlight {
            // the user has already lost their flashlight ... make them feel sad
            return lostFlashlightMessage()
        }
        
        let messages = [
            "That doesn't seem to work.",
            "You don't know how to turn that off.",
            "That cannot be turned off."
        ]
        return randomMessageFromMessages(messages)
    }
    
    func lostFlashlightMessage() -> String {
        let messages = [
            "You lost your flashlight.",
            "You no longer have your flashlight.",
            "You lost your flashlight when you first traveled to Pompeii.",
            "Your flashlight is gone. You should move on.",
            "You lost your treasured flashlight. How can you ever replace it?",
            "With a sad heart you realize your flashlight is gone.",
            "Your trusty flashlight was your most treasured possession. Now it is gone. You hope it is in a better place."
        ]
        return randomMessageFromMessages(messages)
    }
    
    func messageForUseItem(item: CommandAssociatedValue) -> String {
        if !state.hasItemInInventory(item.recognizedItem) {
            return "You don't have \(item.recognizedItem.rawValue)."
        }
        
        if item.remainingTokens.count < 1 {
            return "How do you want to use \(item.recognizedItem.rawValue)?"
        }
        
        guard let preposition = item.remainingTokens.first else {
            return messageForUnknownText("")
        }
        
        let acceptablePrepositions = [ "in", "on", "with" ]
        guard acceptablePrepositions.contains(preposition.lowercaseString) else {
            return messageForUnknownText("")
        }
        
        let remainingTokens = Array(item.remainingTokens.dropFirst())
        let response = InventoryItem.InventoryFromTokens(remainingTokens)
        
        guard let nextItem = response.inventory else {
            return "I don't know how to do that."
        }
        
        if item.recognizedItem.canUseWithItem(nextItem) {
            state.useItems(item.recognizedItem, item2: nextItem)
            return "Using \(item.recognizedItem.rawValue) with \(nextItem.rawValue)."
        }
        
        return messageForUnknownText("")
    }
    
    mutating func messageForTalkToItem(item: CommandAssociatedValue) -> String {
        if !state.hasItemInInventory(item.recognizedItem) && !state.location.inventory.contains(item.recognizedItem) {
            return "Talking to yourself again?"
        }
        
        if item.recognizedItem == .Evangeline {
            return talkToEvangeline()
        }
        
        let itemName = item.recognizedItem.rawValue
        let messages = [
            "You talk to \(itemName). It does not respond.",
            "You would feel silly taking to \(itemName).",
            "Have you ever heard of talking to \(itemName)?",
            "That wouldn't solve anything."
        ]
        return randomMessageFromMessages(messages)
    }
    
    mutating func talkToEvangeline() -> String {
        if !knowsEvangeline {
            knowsEvangeline = true
            return "You talk to the strange girl. She says her name is Evangeline."
        }
        
        switch state.location.region {
        case .MostlyEmptyRoom:
            fatalError("Evangeline cannot be in the mostly empty room.")
        case .Pompeii:
            guard let locationName = PompeiiLocation(rawValue: state.location.name) else {
                fatalError("Invalid location")
            }
            switch locationName {
            case .TownOfPompeii:
                return "You talk to Evangeline. She tells you that you are in Pompeii. She says the only interesting thing to do around here is visit the volcano."
            case .DistantVolcano:
                return "Evangeline tells you the volcano has been more active than usual lately. She stairs up at the smoke rising from the cone. She seems a little nervous. She suggests you explore the volcano more closely."
            case .InsideTheVolcano:
                return "Evangeline points out the large orange gem in the wall of the volcano."
            }
        case .Troy:
            return "Evangeline has nothing to say here."
        }
        
        return "You talk to Evangeline. She seems nice."
    }
    
    func messageForMoveToItem(item: CommandAssociatedValue) -> String {
        if state.canMoveTo(item.recognizedItem) {
            state.moveToLocationOfItem(item.recognizedItem)
            return "You move to \(item.recognizedItem.rawValue)"
        }
        
        return "You cannot get there from here."
    }
}
