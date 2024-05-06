//
//  StocksTableViewCell.swift
//  Upstox_Ritika_iOS
//
//  Created by Ritika Verma on 16/03/24.
//

import UIKit

class StocksTableViewCell: UITableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var ltpLabel: UILabel!
    @IBOutlet weak var pAndLValueLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(data: StocksTableViewCellViewModel) {
        symbolLabel.text = data.symbol
        quantityLabel.text = data.quantity
        ltpLabel.text = data.ltp
        pAndLValueLabel.text = data.pLValue
    }
}



class StocksTableViewCellViewModel {
    
    let symbol: String
    let quantity: String
    let ltp: String
    let pLValue: String
    
    init(data: UserHolding) {
        self.symbol = data.symbol ?? ""
        self.quantity = "\(data.quantity ?? 0)"
        self.ltp = "LTP：₹\(data.ltp ?? 0)"
        let current = Int(data.ltp ?? 0) * (data.quantity ?? 0)
        let investment = Int(data.avgPrice ?? 0) * (data.quantity ?? 0)
        let pLValue = current - investment
        self.pLValue = "P/L: ₹\(pLValue)"
    }
    
}
