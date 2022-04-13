//
//  UpbitAPiService.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/13.
//

import Combine
import Foundation

protocol UpbitAPIServiceable {
    func getAllMarkets() -> AnyPublisher<[Market], RequestError>
    
    func getCandles(from: String, type: CandleType, to: String?, count: String?) -> AnyPublisher<[Candle], RequestError>
}

class UpbitAPIService: HTTPClient, UpbitAPIServiceable {

    func getAllMarkets() -> AnyPublisher<[Market], RequestError> {
        return sendRequest(endpoint: UpbitEndpoint.market)
    }
    
    func getCandles(from: String, type: CandleType, to: String?, count: String?) -> AnyPublisher<[Candle], RequestError> {
        return sendRequest(endpoint: UpbitEndpoint.candles(candleType: type, market: from, to: to, count: count))
    }
}
