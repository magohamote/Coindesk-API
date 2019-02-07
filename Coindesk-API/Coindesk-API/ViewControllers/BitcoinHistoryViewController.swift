//
//  BitcoinHistoryViewController.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class BitcoinHistoryViewController: UIViewController {

    @IBOutlet weak var currentRateView: GradientView?
    @IBOutlet weak var currentRateLabel: UILabel?
    @IBOutlet weak var bitcoinHistoryTableView: RoundedTableView?

    private var bitcoinInfoViewModel = BitcoinInfoViewModel()
    private var currentBitcoinRate: BitcoinInfo? {
        didSet {
            // Replace 0 with an enum and a segmented control
            guard let rate = self.currentBitcoinRate?.bpi[0].rate else {
                return
            }
            
            DispatchQueue.main.async {
                self.currentRateLabel?.text = String(describing: rate)
            }
        }
    }
    
    private var bitcoinHistory = [BPIHistory]() {
        didSet {
            DispatchQueue.main.async {
                self.bitcoinHistoryTableView?.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bitcoinInfoViewModel.delegate = self
        
        setupCurrentRateView()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        bitcoinInfoViewModel.requestCurrentBitcoinData()
        bitcoinInfoViewModel.requestBitcoinDataHistory()
    }
    
    // MARK: - Setup
    private func setupCurrentRateView() {
        currentRateView?.colors = [.purple, .darkPurple]
    }
    
    private func setupTableView() {
        bitcoinHistoryTableView?.dataSource = self
        bitcoinHistoryTableView?.delegate = self
        bitcoinHistoryTableView?.layer.masksToBounds = true
    }
}

// MARK: - UITableViewDataSource
extension BitcoinHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bitcoinHistory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BitcoinRateCell.identifier) as? BitcoinRateCell,
            let date = bitcoinHistory[safe: indexPath.row]?.date,
            let rate = bitcoinHistory[safe: indexPath.row]?.rate else {
            return UITableViewCell()
        }

        cell.config(date: date, rate: rate)
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
    func didReceiveBitcoinHistory(bitcoinHistory: [BPIHistory]) {
        self.bitcoinHistory = bitcoinHistory
    }
    
    func didReceiveDailyRate(bitcoinInfo: BitcoinInfo) {
        currentBitcoinRate = bitcoinInfo
    }
    
    func didFail(error: Error) {
        print("error") // SHOW ERROR
    }
}
