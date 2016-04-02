//
//  Command.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 3/30/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import Foundation

enum CommandError: ErrorType {
    case ParseError
}

struct CommandItem {
    let command: Command
    let strings: [String]
}

struct CommandAssociatedValue {
    let typedItem: String
    let recognizedItem: InventoryItem
    let remainingTokens: [String]
}

enum Command {
    case Examine(CommandAssociatedValue?)
    case Take(CommandAssociatedValue?)
    case Open(CommandAssociatedValue?)
    case Inventory
    case TurnOn(CommandAssociatedValue?)
    case TurnOff(CommandAssociatedValue?)

    private static let examineStrings = [ "examine", "look at", "view", "inspect" ]
    private static let takeStrings = [ "take", "pick up", "grab", "snatch" ]
    private static let openStrings = [ "open" ]
    private static let inventoryStrings = [ "inventory", "show inventory" ]
    private static let turnOnStrings = [ "turn on", "switch on", "enable", "engage" ]
    private static let turnOffStrings = [ "turn off", "switch off", "disable", "disengage" ]
    
    static func tokenIsArticle(token: String) -> Bool {
        let text = token.lowercaseString
        if text == "a" {
            return true
        }
        if text == "an" {
            return true
        }
        if text == "the" {
            return true
        }
        return false
    }
    
    static func command(command: Command, withRemainingTokens tokens: [String]) -> Command? {
        switch command {
        case .Inventory:
            return .Inventory
        case .Examine, .Take, .Open, .TurnOn, .TurnOff:
            break
        }
        
        let known = InventoryItem.InventoryFromTokens(tokens)
        guard let inventory = known.inventory else {
            return nil
        }
        let consumedString = String.stringFromTokens(known.consumedTokens)
        let remainingTokens = known.remainingTokens
        let item = CommandAssociatedValue(typedItem: consumedString, recognizedItem: inventory, remainingTokens: remainingTokens)
        
        switch command {
        case .Examine:
            return .Examine(item)
        case .Take:
            return .Take(item)
        case .Open:
            return .Open(item)
        case .Inventory:
            break
        case .TurnOn:
            return .TurnOn(item)
        case .TurnOff:
            return .TurnOff(item)
        }
        
        return nil
    }
    
    static func commandFromTokens(tokens: [String]) -> Command? {
        let text = String.stringFromTokens(tokens).lowercaseString
        let commands = [ CommandItem(command: .Examine(nil), strings: examineStrings),
                         CommandItem(command: .Take(nil), strings: takeStrings),
                         CommandItem(command: .Open(nil), strings: openStrings),
                         CommandItem(command: .Inventory, strings: inventoryStrings),
                         CommandItem(command: .TurnOn(nil), strings: turnOnStrings),
                         CommandItem(command: .TurnOff(nil), strings: turnOffStrings)
        ]
        
        for command in commands {
            let response = text.beginsWithPrefixInList(command.strings)
            if response.hasPrefix {
                let remainingTokens = self.remainingTokens(tokens, forPrefix: response.prefix!)
                return self.command(command.command, withRemainingTokens: remainingTokens)
            }
        }
        
        return nil
    }
    
    private static func remainingTokens(tokens: [String], forPrefix prefix: String) -> [String] {
        let prefixTokens = prefix.tokenize()
        return Array(tokens.dropFirst(prefixTokens.count))
    }
}

extension String {
    func beginsWithPrefixInList(prefixes: [String]) -> (hasPrefix: Bool, prefix: String?) {
        for prefix in prefixes {
            if self.hasPrefix("\(prefix) ") {
                return (true, prefix)
            } else if self == prefix {
                return (true, prefix)
            }
        }
        return (false, nil)
    }
    
    static func stringFromTokens(tokens: [String], separator: String = " ") -> String {
        return tokens.reduce("") { (text, token) -> String in
            let beginning = (text.characters.count > 0) ? "\(text) " : ""
            return "\(beginning)\(token)"
        }
    }
}