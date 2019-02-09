//
//  BitcoinDetailsViewController.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class BitcoinDetailsViewController: UIViewController {

    @IBOutlet weak var dateLabel: DateLabel?
    @IBOutlet weak var usdRateLabel: UILabel?
    @IBOutlet weak var gbpRateLabel: UILabel?
    @IBOutlet weak var eurRateLabel: UILabel?
    
    var date: String?
    var rate: (usd: Double?, gbp: Double?, eur: Double?)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        
    }
    
    private func setupRate() {
        usdRateLabel?.text = "$\t\(rate.usd?.formattedWithSeparator ?? "-")"
        gbpRateLabel?.text = "£\t\(rate.gbp?.formattedWithSeparator ?? "-")"
        eurRateLabel?.text = "€\t\(rate.eur?.formattedWithSeparator ?? "-")"
        dateLabel?.text = date
    }
}
