//
//  GameState.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 3/31/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import Cocoa

protocol GameStateDelegate {
    func gameState(gameState:GameState, movedToLocation toLocation: Location, fromLocation: Location)
    func gameState(gameState:GameState, didEnableFlashlight enabled: Bool)
    func gameState(gameState:GameState, updatedGem: InventoryItem, inInventory: Bool)
    func gameState(gameState:GameState, didSendMessage message: String)
    func gameState(gameState:GameState, didChangeEvangelineState evangelineState: EvangelineState)
}

enum EvangelineState {
    case Absent
    case Happy
    case Sad
    case Curious
    case Mad
    case Frightened
    
    func image() -> NSImage? {
        switch self {
        case .Happy:
            return NSImage(named: "EvangelineSmiling")
        case .Sad:
            return NSImage(named: "EvangelineSad")
        case .Curious:
            return NSImage(named: "EvangelineCurious")
        case .Mad:
            return NSImage(named: "EvangelineMad")
        case .Frightened:
            return NSImage(named: "EvangelineFrightened")
        case .Absent:
            return nil
        }
    }
}

class GameState {
    let delegate: GameStateDelegate
    var location: Location
    var evangelineState: EvangelineState = .Absent {
        didSet {
            dispatchLater {
                self.delegate.gameState(self, didChangeEvangelineState: self.evangelineState)
            }
        }
    }
    
    private var inventory: [InventoryItem]
    
    var flashlightIsOn = false {
        didSet {
            dispatchLater {
                let message = "Light fills the room. How fortunate you are to have your trusty flashlight. This little guy has been with you on many adventures and has never once failed you. And don't get me started about the battery life. Just spendid!"
                self.delegate.gameState(self, didSendMessage: message)
                self.delegate.gameState(self, didEnableFlashlight: self.flashlightIsOn)
            }
        }
    }
    
    init(delegate: GameStateDelegate, inventory: [InventoryItem], location: Location) {
        self.delegate = delegate
        self.inventory = inventory
        self.location = location
        
        dispatchLater {
            delegate.gameState(self, movedToLocation: location, fromLocation: location)
        }
    }
    
    func numberOfItemsInInventory() -> Int {
        return inventory.count
    }
    
    func inventoryItems() -> [InventoryItem] {
        return inventory
    }
    
    func hasItemInInventory(item: InventoryItem) -> Bool {
        return inventory.contains(item)
    }
    
    func addItemToInventory(item: InventoryItem) {
        inventory.append(item)
        if item == .Evangeline {
            dispatchLater {
                self.evangelineState = .Curious
                self.delegate.gameState(self, didChangeEvangelineState: self.evangelineState)
            }
        }
        switch item {
        case .RedGem, .OrangeGem:
            delegate.gameState(self, updatedGem: item, inInventory: true)
        default:
            break
        }
    }
    
    func removeItemFromInventory(item: InventoryItem) {
        guard let index = inventory.indexOf(item) else {
            fatalError("Item not found")
        }
        inventory.removeAtIndex(index)
        switch item {
        case .RedGem, .OrangeGem:
            delegate.gameState(self, updatedGem: item, inInventory: false)
        default:
            break
        }
    }
    
    func useItems(item1: InventoryItem, item2: InventoryItem) {
        switch item1 {
        case .RedGem:
            guard location.region != .Pompeii else {
                dispatchLater {
                    self.delegate.gameState(self, didSendMessage: "The machine does nothing. Perhaps you can't use that gem right now.")
                }
                return
            }
            dispatchLater {
                guard let location = Region.Pompeii.locations().first else {
                    fatalError("Missing location")
                }
                self.moveToLocation(location)
            }
        case .OrangeGem:
            guard location.region != .Troy else {
                dispatchLater {
                    self.delegate.gameState(self, didSendMessage: "The machine does nothing. Perhaps you can't use that gem right now.")
                }
                return
            }
            dispatchLater {
                self.delegate.gameState(self, movedToLocation: Region.Troy.locations().first!, fromLocation: self.location)
            }
        default:
            break
        }
    }
    
    func canMoveTo(item: InventoryItem) -> Bool {
        switch location.region {
        case .Pompeii:
            guard let locationName = PompeiiLocation(rawValue: location.name) else {
                fatalError("Invalid location")
            }
            switch locationName {
            case .TownOfPompeii, .DistantVolcano:
                return item == .DistantVolcano
            default:
                return false
            }
        default:
            return false
        }
    }
    
    func moveToLocationOfItem(item: InventoryItem) {
        switch item {
        case .DistantVolcano:
            guard self.location.region == .Pompeii else {
                return
            }
            guard let locationName = PompeiiLocation(rawValue: self.location.name) else {
                return
            }
            
            switch locationName {
            case .TownOfPompeii:
                let location = Region.Pompeii.locations()[1]
                dispatchLater {
                    self.moveToLocation(location)
                }
            case .DistantVolcano:
                let location = Region.Pompeii.locations()[2]
                dispatchLater {
                    self.moveToLocation(location)
                }
            default:
                break
            }
        default:
            break
        }
    }
    
    func moveToLocation(location: Location) {
        let oldLocation = self.location
        self.location = location
        delegate.gameState(self, movedToLocation: location, fromLocation: oldLocation)
        if oldLocation.region == .MostlyEmptyRoom {
            removeItemFromInventory(.Flashlight)
        }
        
        switch location.region {
        case .MostlyEmptyRoom:
            break
        case .Pompeii:
            guard let locationName = PompeiiLocation(rawValue: location.name) else {
                fatalError("Invalid location")
            }
            switch locationName {
            case .TownOfPompeii:
                evangelineState = .Happy
            case .DistantVolcano:
                evangelineState = .Curious
            case .InsideTheVolcano:
                evangelineState = .Curious
            }
        case .Troy:
            break;
        }
    }
}

extension GameState {
    func dispatchLater(closure: () -> ()) {
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delay,
                       dispatch_get_main_queue()) {
                        closure()
        }
    }
}
