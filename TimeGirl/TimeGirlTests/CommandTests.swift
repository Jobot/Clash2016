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
        let response = Command.commandFromText(text)
        XCTAssertNil(response.command)
        XCTAssert(response.remainingText == text)
    }

}
