//
//  BPI.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 07.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import SwiftyJSON

struct BPI {
    let code: String?
    let symbol: String?
    let rate: Double
    let bpiDescription: String?
}

extension BPI {
    init?(withJson json: JSON?) {
        guard let rate = json?["rate_float"].double else {
                return nil
        }
        
        self.rate = rate
        
        self.code = json?["code"].string
        self.symbol = json?["symbol"].string
        self.bpiDescription = json?["description"].string
    }
}
