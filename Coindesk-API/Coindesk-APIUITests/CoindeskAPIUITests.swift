//
//  CoindeskAPIUITests.swift
//  Coindesk-APIUITests
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import XCTest

class CoindeskAPIUITests: XCTestCase {

    var app:XCUIApplication?
    
    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
        app = XCUIApplication()
    }

    override func tearDown() {
        app = nil
    }

    func testInterface() {
        guard let app = app else {
            XCTFail()
            return
        }
        
        let bpiHistoryTable = app.tables["bpiHistoryTable"]
        XCTAssertNotNil(bpiHistoryTable)
        bpiHistoryTable.swipeUp()
        bpiHistoryTable.swipeDown()
        
        let refreshButton = app.buttons["refreshButton"]
        XCTAssertNotNil(refreshButton)
        refreshButton.tap()
        
        bpiHistoryTable.cells.element(boundBy: 0).tap()
    }
}
