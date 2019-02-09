//
//  AdjustableLabel.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 09.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class AdjustableLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        adjustsFontSizeToFitWidth = true
    }
}
