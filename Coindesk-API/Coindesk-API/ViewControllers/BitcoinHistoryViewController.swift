//
//  BitcoinHistoryViewController.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class BitcoinHistoryViewController: UIViewController {

    @IBOutlet weak var bitcoinHistoryTableView: UITableView?

    private var bitcoinInfoViewModel = BitcoinInfoViewModel()
    private var bitcoinInfos = [BitcoinInfo]() {
        didSet {
            DispatchQueue.main.async {
                self.bitcoinHistoryTableView?.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bitcoinHistoryTableView?.dataSource = self
        bitcoinHistoryTableView?.delegate = self
        bitcoinInfoViewModel.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension BitcoinHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bitcoinInfos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BitcoinRateCell.identifier) as? BitcoinRateCell else {
            return UITableViewCell()
        }

        cell.config(with: bitcoinInfos[safe: indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BitcoinHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: BitcoinDetailsViewController.identifier) as? BitcoinDetailsViewController else {
            return
        }

        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - BitcoinInfoViewModelDelegate
extension BitcoinHistoryViewController: BitcoinInfoViewModelDelegate {
    func bitcoinInfoViewModelDidReceiveBitcoinInfo(bitcoinInfos: [BitcoinInfo]) {
        self.bitcoinInfos = bitcoinInfos
    }

    func bitcoinInfoViewModelDidFail(error: Error) {
        print("error") // SHOW ERROR
    }
}
