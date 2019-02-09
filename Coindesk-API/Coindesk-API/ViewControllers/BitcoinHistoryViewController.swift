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
    @IBOutlet weak var refreshCurrentRateButton: IncreasedTapTargetButton?
    @IBOutlet weak var bitcoinHistoryTableView: RoundedTableView?
    @IBOutlet weak var emptyTableViewLabel: UILabel?
    
    private var loadingAnimationDuration = 0.25
    private var bitcoinInfoViewModel = BitcoinInfoViewModel()
    private var currentBitcoinRate: BitcoinInfo? {
        didSet {
            guard let rate = currentBitcoinRate?.bpi[.EUR]?.rate,
                let lastUpdate = currentBitcoinRate?.updatedISO else {
                return
            }
            
            DispatchQueue.main.async {
                self.lastUpdateLabel?.text = lastUpdate
                self.currentRateLabel?.text = "\(Currency.EUR.symbol) \(rate.formattedWithSeparator)"
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
        
        setupRefreshCurrentRateButton()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        refreshCurrentRate()   
    }
    
    // MARK: - Setup
    private func setupTableView() {
        bitcoinHistoryTableView?.dataSource = self
        bitcoinHistoryTableView?.delegate = self
        bitcoinHistoryTableView?.tableFooterView = UIView()
    }
    
    private func setupRefreshCurrentRateButton() {
        refreshCurrentRateButton?.addTarget(self, action: #selector(refreshCurrentRateWithError), for: .touchUpInside)
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
    
    private func refreshCurrentRate() {
        bitcoinInfoViewModel.requestCurrentBitcoinRate()
        bitcoinInfoViewModel.requestBpiHistory(currency: Currency.USD)
        bitcoinInfoViewModel.requestBpiHistory(currency: Currency.GBP)
        bitcoinInfoViewModel.requestBpiHistory(currency: Currency.EUR)
    }
    
    @objc private func refreshCurrentRateWithError() {
        if !Reachability.isConnected() {
            showError(error: NetworkError.noInternet)
        }
        refreshCurrentRate()
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
        guard bpiHistory.first?.currency == Currency.EUR else {
            return
        }
        
        if emptyTableViewLabel?.alpha == 1 && !bpiHistory.isEmpty {
            UIView.animate(withDuration: loadingAnimationDuration) {
                self.emptyTableViewLabel?.alpha = 0
            }
        }
        self.bpiHistory = bpiHistory
    }
    
    func didReceiveDailyRate(bitcoinInfo: BitcoinInfo) {
        currentBitcoinRate = bitcoinInfo
    }
    
    func didFail(error: DetailedError) {
        switch error {
        case DataError.noOfflineData:
            showEmptyTableViewLabel()
        default:
            showError(error: error)
        }
    }
    
    private func showEmptyTableViewLabel() {
        if self.bpiHistory.isEmpty {
            UIView.animate(withDuration: loadingAnimationDuration) {
                self.emptyTableViewLabel?.alpha = 1
                self.showCurrentRate()
                self.lastUpdateLabel?.noUpdate()
                self.currentRateLabel?.noRate()
            }
        } else {
            showError(error: UnknowError.unexpectedError)
        }
    }
}
