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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        textField.delegate = self
        textField.placeholderString = "What do you want to do now?"
        
        parser = TextParser()
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
        appendMessage(text, toTextView: textView)
        guard let command = parser.parseCommandFromText(text) else {
            appendMessage("I do not understand.", toTextView: textView)
            return
        }
        processCommand(command)
    }
    
    func processCommand(command: Command) {
        var message: String
        switch command {
        case let .Examine(item):
            message = "You do not see \(item) here."
        case let .Take(item):
            message = "You cannot take \(item)."
        case let .Open(item):
            message = "You cannot seem to open \(item)."
        }
        
        appendMessage(message, toTextView: textView)
    }
    
    func appendMessage(message: String, toTextView textView: NSTextView) {
        guard let string = textView.string else {
            return
        }
        
        textView.string = "\(string)\n\(message)"
    }
}
