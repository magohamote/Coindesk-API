//
//  DateLabel.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 08.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class DateLabel: UILabel {
    let dateFormatter = DateFormatter()

    override var text: String? {
        didSet {
            guard let text = text else { return }
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let formattedDate = dateFormatter.date(from: text) else { return }
            dateFormatter.dateFormat = "E, d MMM yyyy"
            self.text = dateFormatter.string(from: formattedDate)
        }
    }
}
