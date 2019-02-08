//
//  BPIHistory.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 07.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import Foundation

struct BPIHistory {
    let date: String
    let rate: Double
    let currency: Currency
}

extension BPIHistory: Codable {
    static func archiveURL(for currency: Currency) -> URL? {
        switch currency {
        case .USD:
            return FileManagerHelper.documentsDirectory?.appendingPathComponent("usdBpiHistory")
        case .GBP:
            return FileManagerHelper.documentsDirectory?.appendingPathComponent("gbpBpiHistory")
        case .EUR:
            return FileManagerHelper.documentsDirectory?.appendingPathComponent("eurBpiHistory")
        }
    }
}

enum Currency: String, Codable {
    case USD
    case EUR
    case GBP
    
    init?(id : Int) {
        switch id {
        case 0: self = .USD
        case 1: self = .GBP
        case 2: self = .EUR
        default: return nil
        }
    }
    
    var symbol: String {
        switch self {
        case .USD: return "$"
        case .GBP: return "£"
        case .EUR: return "€"
        }
    }
}
