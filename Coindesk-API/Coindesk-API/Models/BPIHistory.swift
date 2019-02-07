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
}

extension BPIHistory: Codable {
    static let archiveURL = FileManagerHelper.documentsDirectory?.appendingPathComponent("bpiHistory")
}
