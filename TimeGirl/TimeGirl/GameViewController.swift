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
    
    @IBOutlet var redGemImageView: NSImageView!
    @IBOutlet var orangeGemImageView: NSImageView!
    @IBOutlet var yellowGemImageView: NSImageView!
    @IBOutlet var greenGemImageView: NSImageView!
    @IBOutlet var blueGemImageView: NSImageView!
    @IBOutlet var indigoGemImageView: NSImageView!
    @IBOutlet var violetGemImageView: NSImageView!
    
    var parser: TextParser!
    var state: GameState!
    var messenger: Messenger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        view.wantsLayer = true
        
        imageView.layer?.cornerRadius = 5.0
        imageView.layer?.masksToBounds = true
        
        textField.delegate = self
        
        let attributes = [ NSForegroundColorAttributeName : NSColor.grayColor() ]
        let placeholderString = "What do you want to do now?"
        textField.placeholderAttributedString = NSAttributedString(string: placeholderString, attributes: attributes)
        
        parser = TextParser()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if state == nil {
            configureInitialState()
        }
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
            let message = messenger.messageForUnknownText(text)
            echoResponse(message, toTextView: textView)
            return
        }
        processCommand(command)
    }
    
    func processCommand(command: Command) {
        var message: String
        switch command {
        case let .Examine(item):
            message = messenger.messageForExamineItem(item)
        case let .Take(item):
            message = messenger.messageForTakeItem(item)
        case let .Open(item):
            message = messenger.messageForOpenItem(item)
        case .Inventory:
            message = messenger.messageForInventory()
        }
        
        echoResponse(message, toTextView: textView)
    }
    
    func echoCommand(command: String, toTextView textView: NSTextView) {
        appendMessage(command, toTextView: textView, textColor: NSColor.grayColor())
    }
    
    func echoResponse(response: String, toTextView textView: NSTextView) {
        appendMessage("\(response)\n", toTextView: textView)
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
    
    // MARK: - State Changes
    func configureInitialState() {
        let region = Region.Pompeii
        guard let location = region.locations().first else {
            fatalError("Unable to read first location")
        }
        state = GameState(delegate: self, inventory: [], location: location)
        changeToLocation(location)
        
        messenger = Messenger(state: state)
    }
    
    func changeToLocation(toLocation: Location, fromLocation: Location? = nil) {
        // TODO: Animation would be nice
        guard let layer = view.layer else {
            print("No layer found!")
            return
        }
        
        layer.backgroundColor = toLocation.region.gemColor().CGColor
        
        imageView.image = toLocation.backgroundImage
    }
}

extension GameViewController: GameStateDelegate {
    func gameState(gameState: GameState, movedToLocation toLocation: Location, fromLocation: Location) {
        changeToLocation(toLocation, fromLocation: fromLocation)
    }
}
