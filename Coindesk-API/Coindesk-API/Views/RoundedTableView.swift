//
//  RoundedTableView.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 07.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class RoundedTableView: UITableView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8.0
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
