//
//  BPIHistoryCell.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class BPIHistoryCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: DateLabel?
    @IBOutlet weak var rateLabel: PaddedTwoSizeLabel?
    
    func config(date: String, rate: Double, increased: Bool) {
        dateLabel?.text = date
        rateLabel?.text = rate.formattedWithSeparator
        rateLabel?.apply(textStyle: .title3)
        dateLabel?.textColor = .darkPurple
        rateLabel?.backgroundColor = increased ? .lightGreenFade : .lightRedFade
    }
}
