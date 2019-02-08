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
    let updatedISO: String
    let bpi: [Currency: BPI]
}

extension BitcoinInfo {
    init?(withJson json: JSON?) {
        guard let time = json?["time"],
        let updated = time["updated"].string,
        let updatedISO = time["updatedISO"].string,
        let usdJson = json?["bpi"]["USD"],
        let gbpJson = json?["bpi"]["GBP"],
        let eurJson = json?["bpi"]["EUR"],
        let usd = BPI(withJson: usdJson),
        let gbp = BPI(withJson: gbpJson),
        let eur = BPI(withJson: eurJson) else {
            return nil
        }
        
        var bpi = [Currency: BPI]()
        bpi[.USD] = usd
        bpi[.GBP] = gbp
        bpi[.EUR] = eur
        
        self.updated = updated
        self.updatedISO = updatedISO
        self.bpi = bpi
    }
}

extension BitcoinInfo: Codable {
    static let archiveURL = FileManagerHelper.documentsDirectory?.appendingPathComponent("bitcoinInfo")
}
