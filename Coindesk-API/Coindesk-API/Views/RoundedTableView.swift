//
//  RoundedTableView.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 07.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class RoundedTableView: UITableView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        refreshControl = UIRefreshControl()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = Design.cornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
