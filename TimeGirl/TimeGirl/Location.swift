//
//  Location.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 3/31/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import Cocoa

enum MostlyEmptyRoomLocation: String {
    case MostlyEmptyRoom = "Mostly empty room"
}

enum PompeiiLocation: String {
    case TownOfPompeii = "Town of Pompeii"
    case InsideTheVolcano = "Inside the volcano"
}

enum TroyLocation: String {
    case GatesOfTroy = "Gates of Troy"
    case TownOfTroy = "Town of Troy"
}

enum Region {
    case MostlyEmptyRoom
    case Pompeii
    case Troy
    
    func gemColor() -> NSColor {
        switch self {
        case .MostlyEmptyRoom:
            return NSColor.darkGrayColor()
        case .Pompeii:
            return NSColor.redColor()
        case .Troy:
            return NSColor.orangeColor()
        }
    }
    
    func locations() -> [Location] {
        switch self {
        case .MostlyEmptyRoom:
            return [
                Location(name: MostlyEmptyRoomLocation.MostlyEmptyRoom.rawValue, region: self, inventory: [ .RedGem, .Door, .TimeMachine ])
            ]
        case .Pompeii:
            return [
                Location(name: PompeiiLocation.TownOfPompeii.rawValue, region: self, inventory: [ .TimeMachine ]),
                Location(name: PompeiiLocation.InsideTheVolcano.rawValue, region: self, inventory: [ .OrangeGem ])
            ]
        case .Troy:
            return [
                Location(name: TroyLocation.GatesOfTroy.rawValue, region: self, inventory: []),
                Location(name: TroyLocation.TownOfTroy.rawValue, region: self, inventory: [])
            ]
        }
    }
}

class Location {
    let name: String
    let region: Region
    var inventory: [InventoryItem]
    var backgroundImage: NSImage? {
        var imagePath = ""
        switch region {
        case .MostlyEmptyRoom:
            let gemShown = gemIsShown
            if flashlightIsOn {
                imagePath = gemShown ? "EmptyRoom" : "EmptyRoomNoGem"
            } else {
                imagePath = gemShown ? "DarkEmptyRoom" : "DarkEmptyRoomNoGem"
            }
        case .Pompeii:
            guard let locationName = PompeiiLocation(rawValue: name) else {
                fatalError("Location name \"\(name)\" does not match enum")
            }
            switch locationName {
            case .TownOfPompeii:
                imagePath = "TownOfPompeii"
            case .InsideTheVolcano:
                imagePath = "InsideTheVolcano"
            }
        case .Troy:
            guard let locationName = TroyLocation(rawValue: name) else {
                fatalError("Location name \"\(name)\" does not match enum")
            }
            switch locationName {
            case .GatesOfTroy:
                imagePath = "GatesOfTroy"
            case .TownOfTroy:
                imagePath = "TownOfTroy"
            }
        }
        return NSImage(named: imagePath)
    }
    var flashlightIsOn: Bool {
        guard let appDelegate = NSApplication.sharedApplication().delegate as? AppDelegate else {
            fatalError("Unable to retrieve App Delegate")
        }
        return appDelegate.gameState.flashlightIsOn
    }
    var gemIsShown: Bool {
        guard let appDelegate = NSApplication.sharedApplication().delegate as? AppDelegate else {
            fatalError("Unable to retrieve App Delegate")
        }
        return !appDelegate.gameState.hasItemInInventory(.RedGem)
    }
    var descriptionGiven: Bool = false
    
    init(name: String, region: Region, inventory: [InventoryItem]) {
        self.name = name
        self.region = region
        self.inventory = inventory
    }
    
    func describeLocation() -> String {
        if descriptionGiven {
            return secondDescription()
        } else {
            descriptionGiven = true
            return firstDescription()
        }
    }
    
    private func firstDescription() -> String {
        switch region {
        case .MostlyEmptyRoom:
            return "You awake in an dark room. You have a slight headache and you have no idea where you are. There's not much to see in the dark."
        case .Pompeii:
            return "You sense movement all around you, although you remain standing completely still. You look around and suddenly realize you are no longer in the mostly empty room. Now you are standing in a street of an ancient yet bustling city. Given the look of the architecture and the volcano looming in the distance you judge this is ancient Pompeii. But how did you get here?\n\nYour headache seems to be gone, and you seem to have misplaced your flashlight."
        default:
            fatalError("Not yet implemented")
        }
    }
    
    private func secondDescription() -> String {
        switch region {
        case .MostlyEmptyRoom:
            if flashlightIsOn {
                return "You are in a mostly empty room. To your left you see a door. To your right you see a strange, star-shaped machine. You notice each point of the star has what looks like an empty mounting bracket. There is a big red gem lying on the floor."
            } else {
                return "You are in a dark room. There's not much to see in the dark."
            }
        case .Pompeii:
            return "You are standing in an ancient city. The city is bustling with activity. Smoke looms in the distance. On the ground behind you is the strange machine that brought you here."
        default:
            fatalError("Not yet implemented")
        }
    }
}
