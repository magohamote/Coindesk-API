//
//  MockService.swift
//  Coindesk-APITests
//
//  Created by Cédric Rolland on 10.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import SwiftyJSON

@testable import Coindesk_API

class MockService: Service {
    
    override func requestCurrentBitcoinData(completion: @escaping completionBlock<BitcoinInfo>) {
        requestBitcoinData() { response, error in
            completion(response, error)
        }
    }
    
    override func requestBpiHistoryData(currency: Currency, from: String, to: String, completion: @escaping completionBlock<[BPIHistory]>) {
        requestBpiHistoryData(currency: currency) { response, error in
            completion(response, error)
        }
    }
    
    private func requestBitcoinData(completion: @escaping completionBlock<BitcoinInfo>) {
        let testDataPath = "bitcoin_info"
        
        guard let data = getTestData(path: testDataPath) else {
            return
        }
        
        do {
            MockRequest.response.json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            completion(nil, RequestError.invalidResponse)
            return
        }
        
        _ = MockRequest(request: "dummyURL").responseJSON { (_, _, json, _) -> Void in
            guard let json = json else {
                completion(nil, DataError.badFormat)
                return
            }
            
            let responseJSON = JSON(json)
            guard let bitcoinInfo = BitcoinInfo(withJson: responseJSON) else {
                completion(nil, DataError.badFormat)
                return
            }
            
            completion(bitcoinInfo, nil)
        }
    }
    
    private func requestBpiHistoryData(currency: Currency, completion: @escaping completionBlock<[BPIHistory]>) {
        let testDataPath = "bpi_history"
        
        guard let data = getTestData(path: testDataPath) else {
            return
        }
        
        do {
            MockRequest.response.json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            completion(nil, RequestError.invalidResponse)
            return
        }
        
        _ = MockRequest(request: "dummyURL").responseJSON { (_, _, json, _) -> Void in
            guard let json = json else {
                completion(nil, DataError.badFormat)
                return
            }
            let responseJSON = JSON(json)
            var bpiArray = [BPIHistory]()
            for data in responseJSON["bpi"]{
                if let rate = data.1.double {
                    bpiArray.append(BPIHistory(date: data.0, rate: rate, currency: currency))
                }
            }
            
            completion(bpiArray.sorted(by: { $0.date > $1.date }), nil)
        }
    }
    
    private func getTestData(path: String) -> Data? {
        let testBundle = Bundle(for: type(of: self))
        guard let path = testBundle.path(forResource: path, ofType: "json") else {
            return nil
        }
        
        return try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
    }
}
