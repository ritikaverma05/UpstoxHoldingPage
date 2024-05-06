//
//  Model.swift
//  Upstox_Ritika_iOS
//
//  Created by Ritika Verma on 11/03/24.
//

import Foundation

struct HoldingList: Codable {
    let userHolding: [UserHolding]?
}

struct UserHolding: Codable {
    let symbol: String?
    let quantity: Int?
    let ltp: Double?
    let avgPrice: Double?
    let close: Int?
}
