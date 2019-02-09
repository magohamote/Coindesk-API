//
//  LastUpdateLabel.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 08.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class LastUpdateLabel: UILabel {
    let stringToDateFormatter = StringToDateFormatter()
    
    override var text: String? {
        didSet {
            guard let text = text else { return }
            stringToDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            guard let formattedDate = stringToDateFormatter.date(from: text) else { return }
            stringToDateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
            self.text = "Last update: \(stringToDateFormatter.string(from: formattedDate))"
            
            if Reachability.isConnected() {
                textColor = .lightGreen
            } else {
                textColor = .lightRed
            }
        }
    }
}
