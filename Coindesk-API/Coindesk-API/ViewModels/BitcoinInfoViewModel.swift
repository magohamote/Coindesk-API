//
//  BitcoinInfoViewModel.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import Foundation

protocol BitcoinInfoViewModelDelegate: AnyObject {
    func didReceiveBpiHistory(bpiHistory: [BPIHistory])
    func didReceiveDailyRate(bitcoinInfo: BitcoinInfo)
    func didFail(error: Error)
}

class BitcoinInfoViewModel {

    weak var delegate: BitcoinInfoViewModelDelegate?
    
    private var service: Service?
    private var lastUpdatedISO: String?
    
    private let dateToStringFormatter = DateToStringFormatter()
    private let stringToDateFormatter = StringToDateFormatter()
    private var historyLengthInDay = 14
    
    init(service: Service = Service()) {
        self.service = service
    }
    
    func requestCurrentBitcoinData() {
        if dataIsExpired(withPrecision: true) {
            service?.requestCurrentBitcoinData(completion: completionBlockUniqueResult)
        } else {
            guard let bitcoinInfo = loadData(type: BitcoinInfo.self, path: BitcoinInfo.archiveURL) else {
                delegate?.didFail(error: FormatError.badFormatError)
                return
            }
            
            delegate?.didReceiveDailyRate(bitcoinInfo: bitcoinInfo)
        }
    }
    
    func requestBpiHistory(currency: Currency) {
        if dataIsExpired(withPrecision: false) {
            guard let fromDate = Calendar.current.date(byAdding: .day, value: -historyLengthInDay, to: Date()) else {
                delegate?.didFail(error: FormatError.badFormatError)
                return
            }
            
            let fromDateString = dateToStringFormatter.string(from: fromDate)
            let toDateString = dateToStringFormatter.string(from: Date())
        
            service?.requestBpiHistory(currency: currency, from: fromDateString, to: toDateString, completion: completionBlockMultipleResult)
        } else {
            guard let bpiHistory = loadData(type: [BPIHistory].self, path: BPIHistory.archiveURL(for: currency)) else {
                delegate?.didFail(error: FormatError.badFormatError)
                return
            }
            
            delegate?.didReceiveBpiHistory(bpiHistory: bpiHistory)
        }
    }
}

// MARK: - Completion blocks
private extension BitcoinInfoViewModel {
    func completionBlockMultipleResult(result: [BPIHistory]?, error: Error?) {
        guard let bpiHistory = completionBlock(result: result, error: error) as? [BPIHistory] else { return }
        
        if bpiHistory.count > 0 {
            saveData(data: bpiHistory, path: BPIHistory.archiveURL(for: bpiHistory.first!.currency))
        }
        
        delegate?.didReceiveBpiHistory(bpiHistory: bpiHistory)
    }
    
    func completionBlockUniqueResult(result: BitcoinInfo?, error: Error?) {
        guard let result = result, let bitcoinInfo = completionBlock(result: result, error: error) as? BitcoinInfo else { return }
        lastUpdatedISO = bitcoinInfo.updatedISO
        saveData(data: bitcoinInfo, path: BitcoinInfo.archiveURL)
        delegate?.didReceiveDailyRate(bitcoinInfo: bitcoinInfo)
    }
    
    func completionBlock(result: Any?, error: Error?) -> Any? {
        guard let result = result else {
            if let error = error {
                delegate?.didFail(error: error)
            }

            return nil
        }
        
        return result
    }
    
    func dataIsExpired(withPrecision: Bool) -> Bool {
        guard let lastUpdatedISO = lastUpdatedISO,
            let lastUpdate = stringToDateFormatter.date(from: lastUpdatedISO) else { return true }
        
        // We fetch new data only if the previous one is expired
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: Date())
        dateComponents.month = calendar.component(.month, from: Date())
        dateComponents.day = calendar.component(.day, from: Date())

        if withPrecision {
            dateComponents.hour = calendar.component(.hour, from: Date())
            dateComponents.minute = calendar.component(.minute, from: Date())
        }
        
        guard let currentDate = calendar.date(from: dateComponents) else { return true }
        
        return lastUpdate < currentDate
    }
}

// MARK: - Save/Load data
private extension BitcoinInfoViewModel {
    func saveData<T: Codable>(data: T, path: URL?) {
        guard let path = path else { return }
        
        do {
            let encodedData = try PropertyListEncoder().encode(data)
            let data = try NSKeyedArchiver.archivedData(withRootObject: encodedData, requiringSecureCoding: false)
            try data.write(to: path)
            
        } catch let error {
            print(error.localizedDescription)
            // TODO Show error
        }
    }
    
    func loadData<T: Codable>(type: T.Type, path: URL?) -> T? {
        guard let path = path else { return nil }
        
        do {
            let data = try Data(contentsOf: path)
            guard let unarchivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data else { return nil }
            let decodedData = try PropertyListDecoder().decode(T.self, from: unarchivedData)
            return decodedData
            
        } catch let error {
            print(error.localizedDescription)
            // TODO Show error
            return nil
        }
    }
}
