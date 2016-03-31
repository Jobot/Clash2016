//
//  TextParserTests.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 3/30/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import XCTest
@testable import TimeGirl

class TextParserTests: XCTestCase {
    
    var parser: TextParser!

    override func setUp() {
        super.setUp()
        
        parser = TextParser()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParsingReturnsNilWithBogusCommand() {
        let command = parser.parseCommandFromText("THIS IS A BOGUS COMMAND")
        XCTAssertNil(command)
    }
    
    func testParsingReturnsNilWithEmptyCommand() {
        let command = parser.parseCommandFromText("    ")
        XCTAssertNil(command)
    }
    
    func testParsingReturnsExamineCommand() {
        guard let command = parser.parseCommandFromText("  exaMine diamond") else {
            XCTFail()
            return
        }
        switch command {
        case let .Examine(item):
            XCTAssert(item == "diamond")
        default:
            XCTFail()
        }
    }
    
    func testTokenizingReturnsCorrectNumberOfItems() {
        let text = "This is a normal sentence"
        let tokens = text.tokenize()
        XCTAssert(tokens.count == 5)
    }
    
    func testTokenizingHandlesExtraSpaces() {
        let text = "This is text with too  many   spaces"
        let tokens = text.tokenize()
        XCTAssert(tokens.count == 7)
    }
    
    func testTokenizingHandlesPunctuation() {
        let punctuation = [ ".", "?", "!" ]
        for ending in punctuation {
            let text = "This is a sentence with punctuation\(ending)"
            let tokens = text.tokenize()
            guard let lastToken = tokens.last else {
                XCTFail()
                return
            }
            XCTAssert(lastToken == "punctuation")
        }
    }

}
