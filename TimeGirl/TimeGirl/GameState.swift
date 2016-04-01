//
//  GameState.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 3/31/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import Foundation

protocol GameStateDelegate {
    func gameState(gameState:GameState, movedToLocation: Location, fromLocation: Location)
}

class GameState {
    let delegate: GameStateDelegate
    var inventory: [String]
    var location: Location
    
    init(delegate: GameStateDelegate, inventory: [String], location: Location) {
        self.delegate = delegate
        self.inventory = inventory
        self.location = location
    }
}
