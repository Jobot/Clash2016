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
    func gameState(gameStage:GameState, didEnableFlashlight enabled: Bool)
}

class GameState {
    let delegate: GameStateDelegate
    var inventory: [InventoryItem]
    var location: Location
    
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
