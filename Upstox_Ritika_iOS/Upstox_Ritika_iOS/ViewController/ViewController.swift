//
//  ViewController.swift
//  Upstox_Ritika_iOS
//
//  Created by Ritika Verma on 11/03/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var totalInvestmentValueLabel: UILabel!
    @IBOutlet weak var todaysProfitAndLossLabel: UILabel!
    @IBOutlet weak var profitAndLossLabel: UILabel!
    @IBOutlet weak var detailView: UIStackView!
    @IBOutlet weak var expandDetailButton: UIButton!
    @IBOutlet weak var userHoldingTableView: UITableView!
    var viewModel = HoldingListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.networkCall()
    }
    
    private func setup() {
        userHoldingTableView.sectionHeaderTopPadding = 0
        userHoldingTableView.showsVerticalScrollIndicator = false
        userHoldingTableView.register(UINib(nibName: "StocksTableViewCell", bundle: nil), forCellReuseIdentifier: "StocksTableViewCell")
        userHoldingTableView.allowsSelection = false
    }
    
    private func networkCall() {
        viewModel.fetchHoldings { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.userHoldingTableView.reloadData()
                self.currentValueLabel.text = self.viewModel.currentValue
                self.totalInvestmentValueLabel.text = self.viewModel.totalInvestment
                self.todaysProfitAndLossLabel.text = self.viewModel.todaysPNL
                self.profitAndLossLabel.text = self.viewModel.totalPNL
            }
        }
    }
    
    @IBAction func expandDetailButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        UIView.animate(withDuration: 0.3) {
            self.detailView.isHidden = !sender.isSelected
            self.view.bringSubviewToFront(self.detailView)
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.stocksCellViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StocksTableViewCell", for: indexPath) as? StocksTableViewCell {
            cell.configureCell(data: self.viewModel.stocksCellViewModel[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = createHeaderView()
        return headerView
    }
    
    private func createHeaderView() -> UIView {
        let headerView = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
        ])
        label.text = "UpStox Holding"
        headerView.backgroundColor = .purple
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return headerView
    }
    
}
