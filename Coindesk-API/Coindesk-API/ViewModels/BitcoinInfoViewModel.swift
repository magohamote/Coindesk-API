//
//  BitcoinInfoViewModel.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import Foundation

protocol BitcoinInfoViewModelDelegate: AnyObject {
    func bitcoinInfoViewModelDidReceiveBitcoinInfo(bitcoinInfos: [BitcoinInfo])
    func bitcoinInfoViewModelDidFail(error: Error)
}

class BitcoinInfoViewModel {

    weak var delegate: BitcoinInfoViewModelDelegate?
}
