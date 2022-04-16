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
    let openingPrice: Double
    let highPrice: Double
    let lowPrice: Double
    let tradePrice: Double
    let change: String
    let signedChangePrice: Double
    let signedChangeRate: Double
    let tradeDate: String
    let tradeTime: String
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case code = "code"
        case openingPrice = "opening_price"
        case highPrice = "high_price"
        case lowPrice = "low_price"
        case tradePrice = "trade_price"
        case change = "change"
        case signedChangePrice = "signed_change_price"
        case signedChangeRate = "signed_change_rate"
        case tradeDate = "trade_date"
        case tradeTime = "trade_time"
    }
}
