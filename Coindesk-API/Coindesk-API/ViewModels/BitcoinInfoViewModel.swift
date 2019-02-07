//
//  BitcoinInfoViewModel.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import Foundation

protocol BitcoinInfoViewModelDelegate: AnyObject {
    func didReceiveBitcoinHistory(bitcoinHistory: [BPIHistory])
    func didReceiveDailyRate(bitcoinInfo: BitcoinInfo)
    func didFail(error: Error)
}

class BitcoinInfoViewModel {

    weak var delegate: BitcoinInfoViewModelDelegate?
    
    private var service: Service?
    
    init(service: Service = Service()) {
        self.service = service
    }
    
    func requestCurrentBitcoinData() {
        service?.requestCurrentBitcoinData(completion: completionBlockUniqueResult)
    }
    
    func requestBitcoinDataHistory() {
        service?.requestBitcoinDataHistory(from: "2013-09-01", to: "2013-09-05", completion: completionBlockMultipleResult)
    }
    
    private func completionBlockMultipleResult(result: [BPIHistory]?, error: Error?) {
        guard let bitcoinHistory = completionBlock(result: result, error: error) as? [BPIHistory] else { return }
     
        delegate?.didReceiveBitcoinHistory(bitcoinHistory: bitcoinHistory)
    }
    
    private func completionBlockUniqueResult(result: BitcoinInfo?, error: Error?) {
        guard let result = result, let bitcoinInfo = completionBlock(result: result, error: error) as? BitcoinInfo else { return }
        
        delegate?.didReceiveDailyRate(bitcoinInfo: bitcoinInfo)
    }
    
    private func completionBlock(result: Any?, error: Error?) -> Any? {
        guard let result = result else {
            if let error = error {
                delegate?.didFail(error: error)
            }

            return nil
        }

        return result
    }
}
