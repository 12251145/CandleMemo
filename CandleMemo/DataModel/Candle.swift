//
//  DayCandle.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/11.
//

import Foundation

struct Candle: Codable, Hashable, Identifiable {
    let id = UUID().uuidString
    let code: String
    let candleDateTimeUTC: String
    let candleDateTimeKST: String
    var openingPrice: Double
    var highPrice: Double
    var lowPrice: Double
    var tradePrice: Double
    let candleAccTradePrice: Double
    let candleAccTradeVolume: Double
    let firstDayOfPeriod: String?
    
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
        case firstDayOfPeriod = "first_day_of_period"
    }
}
