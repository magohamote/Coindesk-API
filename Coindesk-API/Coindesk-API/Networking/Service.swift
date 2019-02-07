//
//  Service.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import SwiftyJSON
import Alamofire
import os.log

class Service {
    
    typealias multipleBitcoinInfoCompletion = (_ response: [BPIHistory]?, _ error: Error?) -> Void
    typealias uniqueBitcoinInfoCompletion = (_ response: BitcoinInfo?, _ error: Error?) -> Void
    
    func requestCurrentBitcoinData(completion: @escaping uniqueBitcoinInfoCompletion) {
        requestBitcoinData(endpoint: Configuration.Endpoints.currentPrice.rawValue) { response, error in
            completion(response, error)
        }
    }
    
    func requestBitcoinDataHistory(from: String, to: String, completion: @escaping multipleBitcoinInfoCompletion) {
        requestMultipleBitcoinData(endpoint: Configuration.Endpoints.priceHistory.rawValue, queryParam: "?start=\(from)&end=\(to)") { response, error in
            completion(response, error)
        }
    }

    private func requestBitcoinData(endpoint: String, completion: @escaping uniqueBitcoinInfoCompletion) {
        guard let url = makeUrl(endpoint: endpoint) else {
            completion(nil, RequestError.badFormatURL)
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            guard response.result.isSuccess, let data = response.result.value else {
                os_log("Unexpected response from the API: %@", log: OSLog.default, type: .error, response.debugDescription)
                completion(nil, RequestError.invalidResponse)
                return
            }
            
            let responseJSON = JSON(data)
            guard let bitcoinInfo = BitcoinInfo(withJson: responseJSON) else {
                completion(nil, FormatError.badFormatError)
                return
            }
            
            completion(bitcoinInfo, nil)
        }
    }
    
    private func requestMultipleBitcoinData(endpoint: String, queryParam: String, completion: @escaping multipleBitcoinInfoCompletion) {
        guard let url = makeUrl(endpoint: endpoint, queryParam: queryParam) else {
            completion(nil, RequestError.badFormatURL)
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            guard response.result.isSuccess, let data = response.result.value else {
                os_log("Unexpected response from the API: %@", log: OSLog.default, type: .error, response.debugDescription)
                completion(nil, RequestError.invalidResponse)
                return
            }
            
            let responseJSON = JSON(data)

            var bpiArray = [BPIHistory]()
            for data in responseJSON["bpi"] {
                if let rate = data.1.double {
                    bpiArray.append(BPIHistory(date: data.0, rate: rate))
                }
            }
            
            completion(bpiArray.sorted(by: { $0.date > $1.date }), nil)
        }
    }
    
    private func makeUrl(endpoint: String, queryParam: String = "") -> URL? {
        guard let url = URL(string: "\(Configuration.environment)\(endpoint)\(queryParam)") else {
            os_log("Error: invalid url: %@", log: OSLog.default, type: .error, "\(Configuration.environment)\(endpoint)")
            return nil
        }
        
        return url
    }
}
