//
//  BitcoinInfo.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 07.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import SwiftyJSON

struct BitcoinInfo {
    let updated: String
    let bpi: [BPI]
}

extension BitcoinInfo {
    init?(withJson json: JSON?) {
        guard let time = json?["time"],
        let updated = time["updated"].string,
        let usdJson = json?["bpi"]["USD"],
        let gbpJson = json?["bpi"]["GBP"],
        let eurJson = json?["bpi"]["EUR"],
        let usd = BPI(withJson: usdJson),
        let gbp = BPI(withJson: gbpJson),
        let eur = BPI(withJson: eurJson) else {
            return nil
        }
        
        var bpi = [BPI]()
        bpi.append(usd)
        bpi.append(gbp)
        bpi.append(eur)
        
        self.updated = updated
        self.bpi = bpi
    }
}
