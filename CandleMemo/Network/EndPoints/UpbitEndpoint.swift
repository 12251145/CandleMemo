//
//  UpbitEndpoint.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/13.
//

import Foundation

enum UpbitEndpoint {
    case market
    case candles(candleType: CandleType, market: String, to: String?, count: Int)
}

enum CandleType: String {
    case day = "days"
    case week = "weeks"
    case month = "months"
}


extension UpbitEndpoint: Endpoint {
    var path: String {
        switch self {
        case .market:
            return "market/all"
        case .candles(candleType: let candleType, market: let market, to: let to, count: let count):
            var components = URLComponents(string: baseURL + "candles" + candleType.rawValue)
            
            let market = URLQueryItem(name: "market", value: market)
            let to = URLQueryItem(name: "to", value: to)
            let count = URLQueryItem(name: "count", value: "\(count)")
                
            components?.queryItems = [market, to, count].compactMap { $0.value != nil ? $0 : nil }
            
            return components?.string ?? ""
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .market, .candles:
            return .get
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .market, .candles:
            return [
                "Accept": "application/json"
            ]
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .market, .candles:
            return nil
        }
    }
}
