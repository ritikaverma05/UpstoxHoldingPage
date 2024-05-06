//
//  Double+Extension.swift
//  Upstox_Ritika_iOS
//
//  Created by Ritika Verma on 16/03/24.
//

import Foundation

extension Double {
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
