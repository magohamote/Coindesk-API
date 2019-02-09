//
//  BitcoinHistoryViewController.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class BitcoinHistoryViewController: UIViewController {

    @IBOutlet weak var currentRateActivityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var currentRateView: GradientView?
    @IBOutlet weak var currentRateLabel: TwoSizeLabel?
    @IBOutlet weak var lastUpdateLabel: LastUpdateLabel?
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl?
    @IBOutlet weak var refreshCurrentRateButton: UIButton?
    @IBOutlet weak var bitcoinHistoryTableView: RoundedTableView?
    @IBOutlet weak var emptyTableViewLabel: UILabel?
    
    private var loadingAnimationDuration = 0.25
    private var bitcoinInfoViewModel = BitcoinInfoViewModel()
    private var currentBitcoinRate: BitcoinInfo? {
        didSet {
            guard let index = currencySegmentedControl?.selectedSegmentIndex,
                let currency = Currency(id: index),
                let rate = currentBitcoinRate?.bpi[currency]?.rate,
                let lastUpdate = currentBitcoinRate?.updatedISO else {
                return
            }
            
            DispatchQueue.main.async {
                self.lastUpdateLabel?.text = lastUpdate
                self.currentRateLabel?.text = "\(currency.symbol) \(rate.formattedWithSeparator)"
                self.showCurrentRate()
            }
        }
    }
    
    private var bpiHistory = [BPIHistory]() {
        didSet {
            DispatchQueue.main.async {
                self.bitcoinHistoryTableView?.reloadData()
            }
        }
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bitcoinInfoViewModel.delegate = self
        lastUpdateLabel?.alpha = 0
        currentRateLabel?.alpha = 0
        emptyTableViewLabel?.alpha = 0
        
        setupCurrentRateView()
        setupRefreshCurrentRateButton()
        setupCurrencySegmentedControl()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        refreshCurrentRate()   
    }
    
    // MARK: - Setup
    private func setupCurrentRateView() {
        currentRateView?.colors = [.purple, .darkPurple]
    }
    
    private func setupTableView() {
        bitcoinHistoryTableView?.dataSource = self
        bitcoinHistoryTableView?.delegate = self
        bitcoinHistoryTableView?.tableFooterView = UIView()
    }
    
    private func setupRefreshCurrentRateButton() {
        refreshCurrentRateButton?.addTarget(self, action: #selector(refreshCurrentRate), for: .touchUpInside)
    }
    
    private func setupCurrencySegmentedControl() {
        currencySegmentedControl?.addTarget(self, action: #selector(updateSelectedCurrency(_:)), for: .valueChanged)
    }
    
    private func showCurrentRate() {
        currentRateActivityIndicator?.stopAnimating()
        UIView.animate(withDuration: loadingAnimationDuration) {
            self.currentRateActivityIndicator?.alpha = 0
            self.currentRateLabel?.alpha = 1
            self.lastUpdateLabel?.alpha = 1
        }
    }
    
    private func hideCurrentRate() {
        currentRateActivityIndicator?.startAnimating()
        UIView.animate(withDuration: loadingAnimationDuration) {
            self.currentRateLabel?.alpha = 0
            self.currentRateActivityIndicator?.alpha = 1
        }
    }
    
    @objc private func refreshCurrentRate() {
        bitcoinInfoViewModel.requestCurrentBitcoinData()
        bitcoinInfoViewModel.requestBpiHistory(currency: Currency.USD)
        bitcoinInfoViewModel.requestBpiHistory(currency: Currency.GBP)
        bitcoinInfoViewModel.requestBpiHistory(currency: Currency.EUR)
    }
    
    @objc private func updateSelectedCurrency(_ sender: UISegmentedControl) {
        guard let currency = Currency(id: sender.selectedSegmentIndex) else {
            return
        }
        
        hideCurrentRate()
        bitcoinInfoViewModel.requestCurrentBitcoinRate()
        bitcoinInfoViewModel.requestBpiHistory(currency: currency)
    }
}

// MARK: - UITableViewDataSource
extension BitcoinHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bpiHistory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BitcoinRateCell.identifier) as? BitcoinRateCell,
            let date = bpiHistory[safe: indexPath.row]?.date,
            let rate = bpiHistory[safe: indexPath.row]?.rate else {
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
        
        vc.rate = bitcoinInfoViewModel.getBitcoinRate(at: indexPath.row)
        vc.date = bpiHistory[safe: indexPath.row]?.date
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - BitcoinInfoViewModelDelegate
extension BitcoinHistoryViewController: BitcoinInfoViewModelDelegate {
    func didReceiveBpiHistory(bpiHistory: [BPIHistory]) {
        guard let index = currencySegmentedControl?.selectedSegmentIndex,
            bpiHistory.first?.currency == Currency(id: index) else {
            return
        }
        
        self.bpiHistory = bpiHistory
    }
    
    func didReceiveDailyRate(bitcoinInfo: BitcoinInfo) {
        currentBitcoinRate = bitcoinInfo
    }
    
    func didFail(error: Error) {
        print("error") // SHOW ERROR
    }
}
