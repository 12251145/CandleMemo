//
//  Ticker.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/09.
//

import Foundation

struct Ticker: Codable {
    let type: String
    let code: String
    let opening_price: Double
    let high_price: Double
    let low_price: Double
    let trade_price: Double
    let change: String
    let signed_change_price: Double
    let signed_change_rate: Double
}
