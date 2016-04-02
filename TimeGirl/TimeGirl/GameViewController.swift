//
//  GameViewController.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 3/31/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import Cocoa
import AVFoundation

class GameViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet var imageView: NSImageView!
    @IBOutlet var textView: NSTextView!
    @IBOutlet var textField: NSTextField!
    @IBOutlet var evangelineImageView: NSImageView!
    
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
    var audioPlayer: AVAudioPlayer?
    
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
        
        if let appDelegate = NSApplication.sharedApplication().delegate as? AppDelegate {
            let region = Region.MostlyEmptyRoom
            guard let location = region.locations().first else {
                fatalError("Unable to read first location")
            }
            state = GameState(delegate: self, inventory: [ .Flashlight ], location: location)
            appDelegate.gameState = state
            messenger = Messenger(state: state)
        }
        
        enableRedGem(false)
        enableOrangeGem(false)
        enableYellowGem(false)
        enableGreenGem(false)
        enableBlueGem(false)
        enableIndigoGem(false)
        enableVioletGem(false)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        changeToLocation(state.location)
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
        evangelineImageView.image = nil
        var message: String
        switch command {
        case .LookAround:
            message = messenger.messageForLookAround()
        case let .Examine(item):
            guard let item = item?.recognizedItem else {
                fatalError("Error unwrapping item")
            }
            message = messenger.messageForExamineItem(item)
        case let .Take(item):
            guard let item = item?.recognizedItem else {
                fatalError("Error unwrapping item")
            }
            message = messenger.messageForTakeItem(item)
        case let .Open(item):
            guard let item = item?.recognizedItem else {
                fatalError("Error unwrapping item")
            }
            message = messenger.messageForOpenItem(item)
        case .Inventory:
            message = messenger.messageForInventory()
        case let .TurnOn(item):
            guard let item = item?.recognizedItem else {
                fatalError("Error unwrapping item")
            }
            message = messenger.messageForTurnOnItem(item)
        case let .TurnOff(item):
            guard let item = item?.recognizedItem else {
                fatalError("Error unwrapping item")
            }
            message = messenger.messageForTurnOffItem(item)
        case let .Use(item):
            guard let item = item else {
                fatalError("Error unwrapping item")
            }
            message = messenger.messageForUseItem(item)
        case let .Talk(item):
            guard let item = item else {
                fatalError("Error unwrapping item")
            }
            message = messenger.messageForTalkToItem(item)
        case let .MoveTo(item):
            guard let item = item else {
                fatalError("Error unwrapping item")
            }
            message = messenger.messageForMoveToItem(item)
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
    
    // MARK: - Gem Views
    func enableImageView(imageView: NSImageView, enabled: Bool, imagePath: String) {
        guard enabled else {
            imageView.image = nil
            return
        }
        
        guard let image = NSImage(named: imagePath) else {
            fatalError("Cannot find image for gem")
        }
        
        imageView.image = image
    }
    
    func enableRedGem(enabled: Bool) {
        enableImageView(redGemImageView, enabled: enabled, imagePath: "RedGem")
    }
    
    func enableOrangeGem(enabled: Bool) {
        enableImageView(orangeGemImageView, enabled: enabled, imagePath: "OrangeGem")
    }
    
    func enableYellowGem(enabled: Bool) {
        enableImageView(yellowGemImageView, enabled: enabled, imagePath: "YellowGem")
    }
    
    func enableGreenGem(enabled: Bool) {
        enableImageView(greenGemImageView, enabled: enabled, imagePath: "GreenGem")
    }
    
    func enableBlueGem(enabled: Bool) {
        enableImageView(blueGemImageView, enabled: enabled, imagePath: "BlueGem")
    }
    
    func enableIndigoGem(enabled: Bool) {
        enableImageView(indigoGemImageView, enabled: enabled, imagePath: "IndigoGem")
    }
    
    func enableVioletGem(enabled: Bool) {
        enableImageView(violetGemImageView, enabled: enabled, imagePath: "VioletGem")
    }
    
    // MARK: - State Changes
    func changeToLocation(toLocation: Location, fromLocation: Location? = nil) {
        // TODO: Animation would be nice
        guard let layer = view.layer else {
            print("No layer found!")
            return
        }
        
        layer.backgroundColor = toLocation.region.gemColor().CGColor
        
        imageView.image = toLocation.backgroundImage
        
        appendMessage(toLocation.describeLocation(), toTextView: textView)
        appendMessage(" ", toTextView: textView)
    }
}

extension GameViewController: GameStateDelegate {
    func gameState(gameState: GameState, movedToLocation toLocation: Location, fromLocation: Location) {
        changeToLocation(toLocation, fromLocation: fromLocation)
        if let musicPath = toLocation.backgroundMusicPath {
            playBackgroundMusic(musicPath)
        } else {
            print("Unable to find background music")
        }
    }
    
    func gameState(gameState: GameState, didEnableFlashlight enabled: Bool) {
        if state.location.region == .MostlyEmptyRoom {
            imageView.image = state.location.backgroundImage
            appendMessage(state.location.describeLocation(), toTextView: textView)
            appendMessage(" ", toTextView: textView)
        }
    }
    
    func gameState(gameState: GameState, updatedGem: InventoryItem, inInventory: Bool) {
        switch updatedGem {
        case .RedGem:
            enableRedGem(inInventory)
        case .OrangeGem:
            enableOrangeGem(inInventory)
        default:
            break
        }
        
        imageView.image = state.location.backgroundImage
    }
    
    func gameState(gameState: GameState, didSendMessage message: String) {
        appendMessage(message, toTextView: textView)
        appendMessage(" ", toTextView: textView)
    }
    
    func gameState(gameState: GameState, didChangeEvangelineState evangelineState: EvangelineState) {
        evangelineImageView.image = evangelineState.image()
    }
}

extension GameViewController {
    func playBackgroundMusic(path: String) {
        guard let data = NSData(contentsOfFile: path) else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("Unable to play music")
        }
    }
}
