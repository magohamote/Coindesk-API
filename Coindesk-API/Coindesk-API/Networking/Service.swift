//
//  Service.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import SwiftyJSON
import Alamofire

class Service {
    
    typealias completionBlock<T: Codable> = (_ response: T?, _ error: DetailedError?) -> Void
    
    func requestCurrentBitcoinData(completion: @escaping completionBlock<BitcoinInfo>) {
        requestBitcoinData() { response, error in
            completion(response, error)
        }
    }
    
    func requestBpiHistoryData(currency: Currency, from: String, to: String, completion: @escaping completionBlock<[BPIHistory]>) {
        requestBpiHistoryData(currency: currency, queryParam: "?currency=\(currency.rawValue)&start=\(from)&end=\(to)") { response, error in
            completion(response, error)
        }
    }

    private func requestBitcoinData(completion: @escaping completionBlock<BitcoinInfo>) {
        guard let url = URL(string: "\(Configuration.environment)\(Configuration.Endpoints.currentPrice.rawValue)") else {
            completion(nil, RequestError.badFormatURL)
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            guard response.result.isSuccess, let data = response.result.value else {
                completion(nil, RequestError.invalidResponse)
                return
            }
            
            let responseJSON = JSON(data)
            guard let bitcoinInfo = BitcoinInfo(withJson: responseJSON) else {
                completion(nil, DataError.badFormat)
                return
            }
            
            completion(bitcoinInfo, nil)
        }
    }
    
    private func requestBpiHistoryData(currency: Currency, queryParam: String, completion: @escaping completionBlock<[BPIHistory]>) {
        guard let url = URL(string: "\(Configuration.environment)\(Configuration.Endpoints.priceHistory.rawValue)\(queryParam)") else {
            completion(nil, RequestError.badFormatURL)
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            guard response.result.isSuccess, let data = response.result.value else {
                completion(nil, RequestError.invalidResponse)
                return
            }
            
            let responseJSON = JSON(data)
            var bpiArray = [BPIHistory]()
            for data in responseJSON["bpi"] {
                if let rate = data.1.double {
                    bpiArray.append(BPIHistory(date: data.0, rate: rate, currency: currency))
                }
            }
            
            completion(bpiArray.sorted(by: { $0.date > $1.date }), nil)
        }
    }
}
