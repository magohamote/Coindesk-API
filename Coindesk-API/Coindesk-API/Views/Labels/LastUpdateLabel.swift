//
//  LastUpdateLabel.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 08.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class LastUpdateLabel: AdjustableLabel {
    let stringToDateFormatter = StringToDateFormatter()
    
    override var text: String? {
        didSet {
            updateColor()
            guard let text = text else { return }
            stringToDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            guard let formattedDate = stringToDateFormatter.date(from: text) else { return }
            stringToDateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
            self.text = "Last update: \(stringToDateFormatter.string(from: formattedDate))"
        }
    }
    
    func noUpdate() {
        updateColor()
        text = "Last update: -"
    }
    
    private func updateColor() {
        if Reachability.isConnected() {
            textColor = .lightGreen
        } else {
            textColor = .lightRed
        }
    }
}
