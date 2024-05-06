//
//  ViewModel.swift
//  Upstox_Ritika_iOS
//
//  Created by Ritika Verma on 11/03/24.
//

import Foundation

protocol HoldingListViewModelProtocol {
    func fetchHoldings(completion: @escaping(()->()))
}

final class HoldingListViewModel: HoldingListViewModelProtocol {
    
    var networkManager: NetworkManagerProtocol
    var stocksCellViewModel: [StocksTableViewCellViewModel] = []
    var currentValue = ""
    var totalInvestment = ""
    var totalPNL = ""
    var todaysPNL = ""
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchHoldings(completion: @escaping (() -> ())) {
        let url = "https://run.mocky.io/v3/bde7230e-bc91-43bc-901d-c79d008bddc8"
        networkManager.getResponseList(path: url, resultType: HoldingList.self) { result in
            switch result {
            case .success(let items):
                self.setupCellModel(holdings: items.userHolding ?? [])
                self.setupDetails(holdings: items.userHolding ?? [])
                completion()
            case .failure(_):
                completion()
            }
        }
    }
    
    func setupCellModel(holdings: [UserHolding]) {
        for holding in holdings {
            let cellModel = StocksTableViewCellViewModel(data: holding)
            self.stocksCellViewModel.append(cellModel)
        }
    }
    
    func setupDetails(holdings: [UserHolding]) {
        let currentValue = holdings.compactMap { ($0.ltp ?? 0) * Double($0.quantity ?? 0) }.reduce(0, +).rounded(toPlaces: 2)
        self.currentValue = "₹ \(currentValue)"
        let totalInvestment = holdings.compactMap { ($0.avgPrice ?? 0) * Double($0.quantity ?? 0) }.reduce(0, +).rounded(toPlaces: 2)
        self.totalInvestment = "₹ \(totalInvestment)"
        totalPNL = "₹ \((currentValue - totalInvestment).rounded(toPlaces: 2))"
        todaysPNL = "₹ \(holdings.compactMap { ( Double($0.close ?? 0) - ($0.ltp ?? 0) ) * Double($0.quantity ?? 0) }.reduce(0, +).rounded(toPlaces: 2))"
    }
}
