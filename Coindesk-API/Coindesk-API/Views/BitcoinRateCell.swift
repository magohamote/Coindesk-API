//
//  BitcoinRateCell.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class BitcoinRateCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var rateLabel: UILabel?
    
    func config(date: String, rate: Double) {
        dateLabel?.text = date
        rateLabel?.text = String(describing: rate)
    }
}
