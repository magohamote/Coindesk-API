//
//  Configuration.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 07.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import Foundation

struct Configuration {
    static let environment = Bundle.main.infoDictionary!["API_BASE_URL_ENDPOINT"] as! String
    
    enum Endpoints: String {
        case currentPrice = "currentprice.json"
        case priceHistory = "historical/close.json"
    }
}
