//
//  TestViewModels.swift
//  Coindesk-APITests
//
//  Created by Cédric Rolland on 10.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import Foundation
import XCTest
@testable import Coindesk_API

class TestViewModels: XCTestCase, BitcoinInfoViewModelDelegate {
    
    var bitcoinInfoViewModel: BitcoinInfoViewModel?
    
    override func setUp() {
        super.setUp()
        bitcoinInfoViewModel = BitcoinInfoViewModel(service: MockService())
        bitcoinInfoViewModel?.delegate = self
    }
    
    override func tearDown() {
        bitcoinInfoViewModel = nil
        super.tearDown()
    }
    
    // MARK: - BitcoinInfo ViewModel
    
    func testUserViewModel() {
        bitcoinInfoViewModel?.requestData()
    }
    
    func didReceiveDailyRate(bitcoinInfo: BitcoinInfo) {
        XCTAssertNotNil(bitcoinInfo)
        XCTAssertEqual(bitcoinInfo.updatedISO, "2019-02-07T09:07:00+00:00")
        XCTAssertEqual(bitcoinInfo.bpi[.USD]?.code, "USD")
        XCTAssertEqual(bitcoinInfo.bpi[.USD]?.rate, 1)
        XCTAssertEqual(bitcoinInfo.bpi[.GBP]?.code, "GBP")
        XCTAssertEqual(bitcoinInfo.bpi[.GBP]?.rate, 2)
        XCTAssertEqual(bitcoinInfo.bpi[.EUR]?.code, "EUR")
        XCTAssertEqual(bitcoinInfo.bpi[.EUR]?.rate, 3)
        
    }
    
    func didReceiveBpiHistory(bpiHistory: [BPIHistory]) {
        XCTAssertNotNil(bpiHistory)
        XCTAssertEqual(bpiHistory.count, 5)
        XCTAssertEqual(bpiHistory[4].rate, 1)
        XCTAssertEqual(bpiHistory[4].date, "2018-09-01")
        XCTAssertEqual(bpiHistory[3].rate, 2)
        XCTAssertEqual(bpiHistory[3].date, "2018-09-02")
        XCTAssertEqual(bpiHistory[2].rate, 3)
        XCTAssertEqual(bpiHistory[2].date, "2018-09-03")
        XCTAssertEqual(bpiHistory[1].rate, 4)
        XCTAssertEqual(bpiHistory[1].date, "2018-09-04")
        XCTAssertEqual(bpiHistory[0].rate, 5)
        XCTAssertEqual(bpiHistory[0].date, "2018-09-05")
    }
    
    func didFail(error: DetailedError) {
        XCTFail()
    }

    func testFailGetBitcoinRate() {
        let bitcoinRate = bitcoinInfoViewModel?.getBitcoinRate(at: -1)
        XCTAssertNil(bitcoinRate?.usd)
        XCTAssertNil(bitcoinRate?.gbp)
        XCTAssertNil(bitcoinRate?.eur)
    }
}
