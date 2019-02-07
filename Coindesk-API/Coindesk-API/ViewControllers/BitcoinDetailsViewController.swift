//
//  BitcoinDetailsViewController.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class BitcoinDetailsViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var usdRateLabel: UILabel?
    @IBOutlet weak var gbpRateLabel: UILabel?
    @IBOutlet weak var eurRateLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (view as? GradientView)?.colors = [.purple, .darkPurple]
        navigationController?.isNavigationBarHidden = false
    }
}
