//
//  GameViewController.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 3/31/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import Cocoa

class GameViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet var imageView: NSImageView!
    @IBOutlet var textView: NSTextView!
    @IBOutlet var textField: NSTextField!
    
    var parser: TextParser!
    var state: GameState!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        textField.delegate = self
        
        let attributes = [ NSForegroundColorAttributeName : NSColor.grayColor() ]
        let placeholderString = "What do you want to do now?"
        textField.placeholderAttributedString = NSAttributedString(string: placeholderString, attributes: attributes)
        
        parser = TextParser()
        state = GameState(inventory: ["A shiny marble", "A peppermint", "Some pocket lint" ], locations: [])
    }
    
    override func controlTextDidEndEditing(obj: NSNotification) {
        guard let textField = obj.object as? NSTextField else {
            return
        }
        
        let text = textField.stringValue
        textField.stringValue = ""
        processText(text)
    }
    
    func processText(text: String) {
        guard text.characters.count > 0 else {
            return
        }
        
        echoCommand(text, toTextView: textView)
        guard let command = parser.parseCommandFromText(text) else {
            let message = messageForUnknownText(text)
            echoResponse(message, toTextView: textView)
            return
        }
        processCommand(command)
    }
    
    func processCommand(command: Command) {
        var message: String
        switch command {
        case let .Examine(item):
            message = messageForExamineItem(item)
        case let .Take(item):
            message = messageForTakeItem(item)
        case let .Open(item):
            message = messageForOpenItem(item)
        case .Inventory:
            message = messageForInventory()
        }
        
        echoResponse(message, toTextView: textView)
    }
    
    func echoCommand(command: String, toTextView textView: NSTextView) {
        appendMessage(command, toTextView: textView, textColor: NSColor.grayColor())
    }
    
    func echoResponse(response: String, toTextView textView: NSTextView) {
        appendMessage(response, toTextView: textView)
    }
    
    func appendMessage(message: String, toTextView textView: NSTextView, textColor: NSColor = NSColor.whiteColor()) {
        guard message.characters.count > 0 else {
            return
        }
        
        guard let storage = textView.textStorage, string = textView.string else {
            return
        }
        
        if string.characters.count > 0 {
            let newLine = NSAttributedString(string: "\n")
            storage.appendAttributedString(newLine)
        }
        
        let secondIndex = message.startIndex.advancedBy(1)
        let firstCharacter = message.substringToIndex(secondIndex).uppercaseString
        let capitalizedMessage = "\(firstCharacter)\(message.substringFromIndex(secondIndex))"
        
        let attributes = [ NSForegroundColorAttributeName : textColor ]
        let attributedMessage = NSAttributedString(string: capitalizedMessage, attributes: attributes)
        storage.appendAttributedString(attributedMessage)
        
        if let newString = textView.string {
            let visibleRange = NSRange(location: newString.characters.count, length: 0)
            textView.scrollRangeToVisible(visibleRange)
        }
    }
    
    // MARK: - Messages
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
                return "\(message)\n\t\(item)"
            }
        }
    }
}
