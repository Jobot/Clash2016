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
    var locations: [Location]
    
    init(inventory: [String], locations: [Location]) {
        self.inventory = inventory
        self.locations = locations
    }
}
