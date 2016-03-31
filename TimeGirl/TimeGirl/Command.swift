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
    case Examine(item: String)
    case Take(item: String)
    case Open(item: String)
    
    private static let examineStrings = [ "examine", "look at", "view", "inspect" ]
    private static let takeStrings = [ "take", "pick up", "grab", "snatch" ]
    private static let openStrings = [ "open" ]
    
    static func stringFromTokens(tokens: [String], separator: String = " ") -> String {
        return tokens.reduce("") { (text, token) -> String in
            let beginning = (text.characters.count > 0) ? "\(text) " : ""
            return "\(beginning)\(token)"
        }
    }
    
    static func itemFromRemainingTokens(tokens: [String]) -> String? {
        guard let item = tokens.first else {
            return nil
        }
        return item
    }
    
    static func command(command: Command, withRemainingTokens tokens: [String]) -> Command? {
        guard let item = itemFromRemainingTokens(tokens) else {
            return nil
        }
        
        switch command {
        case .Examine:
            return .Examine(item: item)
        case .Take:
            return .Take(item: item)
        case .Open:
            return .Open(item: item)
        }
    }
    
    static func commandFromTokens(tokens: [String]) -> Command? {
        let text = stringFromTokens(tokens).lowercaseString
        let commands = [ CommandItem(command: .Examine(item: ""), strings: examineStrings),
                         CommandItem(command: .Take(item: ""), strings: takeStrings),
                         CommandItem(command: .Open(item: ""), strings: openStrings)
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
            }
        }
        return (false, nil)
    }
}