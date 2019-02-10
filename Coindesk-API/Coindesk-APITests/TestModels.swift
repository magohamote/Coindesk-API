//
//  TestModels.swift
//  Coindesk-APITests
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Coindesk_API

class TestModels: XCTestCase {

    // MARK: - BitcoinInfo Model
    
    func testSuccessfulBitcoinInfoJsonInit() {
        guard let data = getTestData(name: "bitcoin_info") else {
            XCTFail()
            return
        }
        
        let jsonData = JSON(data)
        XCTAssertNotNil(BitcoinInfo(withJson: jsonData))
    }
    
    func testFailBitcoinInfoJsonInit() {
        guard let data = getTestData(name: "bad_json") else {
            XCTFail()
            return
        }
        
        let jsonData = JSON(data)
        XCTAssertNil(BitcoinInfo(withJson: jsonData))
    }
    
    // MARK: - BPIHistory Model
    
    func testSuccessfulBPIHistory() {
        guard let data = getTestData(name: "bpi_history") else {
            XCTFail()
            return
        }
        
        var bpiArray = [BPIHistory]()
        for data in JSON(data)["bpi"] {
            if let rate = data.1.double {
                let bpiHistory = BPIHistory(date: data.0, rate: rate, currency: Currency.EUR)
                XCTAssertNotNil(bpiHistory)
                bpiArray.append(bpiHistory)
            }
        }
        
        XCTAssertEqual(bpiArray.count, 5)
    }
    
    func testFailBPIHistory() {
        guard let data = getTestData(name: "bad_json") else {
            XCTFail()
            return
        }
        
        var bpiArray = [BPIHistory]()
        for data in JSON(data)["bpi"] {
            if let rate = data.1.double {
                let bpiHistory = BPIHistory(date: data.0, rate: rate, currency: Currency.EUR)
                XCTAssertNil(bpiHistory)
                bpiArray.append(bpiHistory)
            }
        }
        
        XCTAssertEqual(bpiArray.count, 0)
    }
}
