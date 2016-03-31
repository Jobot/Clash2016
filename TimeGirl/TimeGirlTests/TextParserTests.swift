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
        XCTAssert(command == nil)
    }

}
