//
//  CandleChartService.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/15.
//

import Combine
import Foundation

protocol CandleChartServiceable {

    func getCandles(from: String, type: CandleType, to: String?, count: String?) -> AnyPublisher<[Candle], RequestError>
}

class CandleChartService: HTTPClient, CandleChartServiceable {

    func getCandles(from: String, type: CandleType, to: String?, count: String?) -> AnyPublisher<[Candle], RequestError> {
        return sendRequest(endpoint: UpbitEndpoint.candles(candleType: type, market: from, to: to, count: count))
    }
}
