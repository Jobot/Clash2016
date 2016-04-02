//
//  GameState.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 3/31/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import Foundation

protocol GameStateDelegate {
    func gameState(gameState:GameState, movedToLocation toLocation: Location, fromLocation: Location)
    func gameState(gameState:GameState, didEnableFlashlight enabled: Bool)
    func gameState(gameState:GameState, updatedGem: InventoryItem, inInventory: Bool)
}

class GameState {
    let delegate: GameStateDelegate
    var location: Location
    
    private var inventory: [InventoryItem]
    
    var flashlightIsOn = false {
        didSet {
            dispatchLater { 
                self.delegate.gameState(self, didEnableFlashlight: self.flashlightIsOn)
            }
        }
    }
    
    init(delegate: GameStateDelegate, inventory: [InventoryItem], location: Location) {
        self.delegate = delegate
        self.inventory = inventory
        self.location = location
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
        print("USING \(item1) WITH \(item2)")
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
