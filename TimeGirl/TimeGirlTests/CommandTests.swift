//
//  CommandTests.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 3/30/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import XCTest
@testable import TimeGirl

class CommandTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCommandFromTextReturnsNilAndOriginalStringWithBogusCommand() {
        let text = "THIS IS A BOGUS COMMAND"
        if let _ = Command.commandFromTokens(text.tokenize()) {
            XCTFail()
        }
    }
    
    func testCommandFromTextWithExamine() {
        let text = "EXaMinE ruby"
        guard let command = Command.commandFromTokens(text.tokenize()) else {
            XCTFail()
            return
        }
        
        switch command {
        case let .Examine(item):
            XCTAssert(item == "ruby")
        default:
            XCTFail()
        }
    }
    
    func testCommandFromTextWithExamineSynonyms() {
        let texts = [ "look at ruby",
                      "inspect ruby",
                      "view ruby"]
        for text in texts {
            guard let command = Command.commandFromTokens(text.tokenize()) else {
                XCTFail()
                return
            }
            
            switch command {
            case let .Examine(item):
                XCTAssert(item == "ruby")
            default:
                XCTFail()
            }
        }
    }
    
    func testCommandFromTextWithTake() {
        let text = "TAKe ruby"
        guard let command = Command.commandFromTokens(text.tokenize()) else {
            XCTFail()
            return
        }
        
        switch command {
        case let .Take(item):
            XCTAssert(item == "ruby")
        default:
            XCTFail()
        }
    }
    
    func testCommandFromTextWithTakeSynonyms() {
        let texts = [ "pick up ruby",
                      "grab ruby",
                      "snatch ruby" ]
        for text in texts {
            guard let command = Command.commandFromTokens(text.tokenize()) else {
                XCTFail()
                return
            }
            
            switch command {
            case let .Take(item):
                XCTAssert(item == "ruby")
            default:
                XCTFail()
            }
        }
    }
    
    func testCommandFromTextWithOpen() {
        let text = "opEN the door"
        guard let command = Command.commandFromTokens(text.tokenize()) else {
            XCTFail()
            return
        }
        
        switch command {
        case let .Open(item):
            XCTAssert(item == "the door")
        default:
            XCTFail()
        }
    }
}
