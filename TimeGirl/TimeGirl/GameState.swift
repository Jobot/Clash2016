//
//  GameState.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 3/31/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import Foundation

class GameState {
    var inventory: [String]
    var location: Location
    
    init(inventory: [String], location: Location) {
        self.inventory = inventory
        self.location = location
    }
}
