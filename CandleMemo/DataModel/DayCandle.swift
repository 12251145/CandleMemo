//
//  DayCandle.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/11.
//

import Foundation

struct DayCandle: Codable, Hashable {
    let code: String
    let candleDateTimeUTC: String
    let candleDateTimeKST: String
    let openingPrice: Double
    let highPrice: Double
    let lowPrice: Double
    let tradePrice: Double
    let candleAccTradePrice: Double
    let candleAccTradeVolume: Double
    
    enum CodingKeys: String, CodingKey {
        case code = "market"
        case candleDateTimeUTC = "candle_date_time_utc"
        case candleDateTimeKST = "candle_date_time_kst"
        case openingPrice = "opening_price"
        case highPrice = "high_price"
        case lowPrice = "low_price"
        case tradePrice = "trade_price"
        case candleAccTradePrice = "candle_acc_trade_price"
        case candleAccTradeVolume = "candle_acc_trade_volume"
    }
}
