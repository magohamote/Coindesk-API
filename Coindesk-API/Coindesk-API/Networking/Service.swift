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
    
    typealias completionBlock<T: Codable> = (_ response: T?, _ error: Error?) -> Void
    
    func requestCurrentBitcoinData(completion: @escaping completionBlock<BitcoinInfo>) {
        requestBitcoinData(endpoint: Configuration.Endpoints.currentPrice.rawValue) { response, error in
            completion(response, error)
        }
    }
    
    func requestBpiHistory(from: String, to: String, completion: @escaping completionBlock<[BPIHistory]>) {
        requestBpiHistory(endpoint: Configuration.Endpoints.priceHistory.rawValue,
                          queryParam: "?start=\(from)&end=\(to)") { response, error in
            completion(response, error)
        }
    }

    private func requestBitcoinData(endpoint: String, completion: @escaping completionBlock<BitcoinInfo>) {
        guard let url = makeUrl(endpoint: endpoint) else {
            completion(nil, RequestError.badFormatURL)
            return
        }
        
        Alamofire.request(url).responseJSON { [weak self] response in
            guard let responseJSON = self?.validateResponse(response) else {
                completion(nil, RequestError.invalidResponse)
                return
            }
            
            guard let bitcoinInfo = BitcoinInfo(withJson: responseJSON) else {
                completion(nil, FormatError.badFormatError)
                return
            }
            
            completion(bitcoinInfo, nil)
        }
    }
    
    private func requestBpiHistory(endpoint: String, queryParam: String, completion: @escaping completionBlock<[BPIHistory]>) {
        guard let url = makeUrl(endpoint: endpoint, queryParam: queryParam) else {
            completion(nil, RequestError.badFormatURL)
            return
        }
        
        Alamofire.request(url).responseJSON { [weak self] response in
            guard let responseJSON = self?.validateResponse(response) else {
                completion(nil, RequestError.invalidResponse)
                return
            }
            
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
    
    private func validateResponse(_ response: DataResponse<Any>) -> JSON? {
        guard response.result.isSuccess, let data = response.result.value else {
            os_log("Unexpected response from the API: %@", log: OSLog.default, type: .error, response.debugDescription)
            return nil
        }

        return JSON(data)
    }
}
