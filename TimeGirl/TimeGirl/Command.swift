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

enum Command {
    case Examine(String)
    case Take(String)
    case Open(String)
    case Inventory
    case TurnOn(String)
    case TurnOff(String)

    private static let examineStrings = [ "examine", "look at", "view", "inspect" ]
    private static let takeStrings = [ "take", "pick up", "grab", "snatch" ]
    private static let openStrings = [ "open" ]
    private static let inventoryStrings = [ "inventory", "show inventory" ]
    private static let turnOnStrings = [ "turn on", "switch on", "enable", "engage" ]
    private static let turnOffStrings = [ "turn off", "switch off", "disable", "disengage" ]
    
    static func stringFromTokens(tokens: [String], separator: String = " ") -> String {
        return tokens.reduce("") { (text, token) -> String in
            let beginning = (text.characters.count > 0) ? "\(text) " : ""
            return "\(beginning)\(token)"
        }
    }
    
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
    
    static func itemFromRemainingTokens(tokens: [String]) -> String? {
        guard let firstItem = tokens.first else {
            return nil
        }

        var item = firstItem
        if tokenIsArticle(firstItem) {
            guard tokens.count > 1 else {
                return nil
            }
            let secondItem = tokens[1]
            item = stringFromTokens([item, secondItem])
        }
        
        return item
    }
    
    static func command(command: Command, withRemainingTokens tokens: [String]) -> Command? {
        switch command {
        case .Inventory:
            return .Inventory
        case .Examine, .Take, .Open, .TurnOn, .TurnOff:
            break
        }
        
        guard let item = itemFromRemainingTokens(tokens) else {
            return nil
        }
        
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
        let text = stringFromTokens(tokens).lowercaseString
        let commands = [ CommandItem(command: .Examine(""), strings: examineStrings),
                         CommandItem(command: .Take(""), strings: takeStrings),
                         CommandItem(command: .Open(""), strings: openStrings),
                         CommandItem(command: .Inventory, strings: inventoryStrings),
                         CommandItem(command: .TurnOn(""), strings: turnOnStrings),
                         CommandItem(command: .TurnOff(""), strings: turnOffStrings)
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
}