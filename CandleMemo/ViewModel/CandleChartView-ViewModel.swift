//
//  CandleChartView-ViewModel.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/14.
//

import Combine
import Foundation
import SwiftUI

extension CandleChartView {
    class ViewModel: ObservableObject {
        @Published var currentCandles: [Candle] = []
        @Published var graphSize = 30
        @Published var graphMoved = 0
        @Published var currentCandleType = CandleType.day
        
        @Published var ex = 0
        
        let service = CandleChartService()
        
        var currentDate = ""
        
        private var cancellables = Set<AnyCancellable>()
        
        func requestCandles(code: String, type: CandleType, to: String? = nil, count: String? = "200") {
            service.getCandles(from: code, type: type, to: to, count: count)
                .receive(on: RunLoop.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("get all candles!")
                    case .failure(let error):
                        print(error.customMessage)
                    }
                } receiveValue: { [weak self] candles in
                    if self?.currentCandles.first?.candleDateTimeKST != candles.first?.candleDateTimeKST {
                        self?.currentCandles = candles + (self?.currentCandles ?? [])
                    }
                    self?.graphSize = self?.graphSize ?? 0 < (self?.currentCandles.count ?? 0) ? self?.graphSize ?? 0 : (self?.currentCandles.count ?? 0)
                }
                .store(in: &cancellables)
        }
        
        func getGroupHigh(graphSize: Int, graphMoved: Int, code: String) -> CGFloat {
            if currentCandles.isEmpty { return 0 }
            
            let start = graphMoved
            let end = graphSize + graphMoved - 1
            
            var top = currentCandles[start].highPrice

            for i in start...end {
                top = currentCandles[i].highPrice > top ? currentCandles[i].highPrice : top
            }

            return CGFloat(top)
        }
        
        func getGroupLow(graphSize: Int, graphMoved: Int, code: String) -> CGFloat {
            if currentCandles.isEmpty { return 0 }
            
            let start = graphMoved
            let end = graphSize + graphMoved - 1
            
            var bottom = currentCandles[start].lowPrice

            for i in start...end {
                bottom = currentCandles[i].lowPrice < bottom ? currentCandles[i].lowPrice : bottom
            }

            return CGFloat(bottom)
        }
        
        func getGroupHeight(graphSize: Int, graphMoved: Int, code: String) -> CGFloat {
            if currentCandles.isEmpty { return 1 }

            return getGroupHigh(graphSize: graphSize , graphMoved: graphMoved, code: code) - getGroupLow(graphSize: graphSize, graphMoved: graphMoved, code: code)
        }
        
        func getHeight(part: CandlePart, graphSize: Int, graphMoved: Int, candle: Candle, code: String, ticker: Ticker) -> CGFloat {
            if currentCandles.isEmpty { return 0 }

            if ticker.tradeDate != currentDate {
                currentDate = ticker.tradeDate
                
                requestCandles(code: ticker.code, type: currentCandleType, count: "1")
            }
            
            
            let groupHigh = getGroupHigh(graphSize: graphSize, graphMoved: graphMoved, code: code)
            let groupLow = getGroupLow(graphSize: graphSize, graphMoved: graphMoved, code: code)
            
            let groupHeight = getGroupHeight(graphSize: graphSize, graphMoved: graphMoved, code: code)
            var partHeight = groupHeight
            
            switch part {
            case .topEmpty:
                partHeight = groupHigh - candle.highPrice
            case .topTail:
                if candle.candleDateTimeKST == currentCandles.first?.candleDateTimeKST {
                    partHeight = candle.openingPrice > ticker.tradePrice ? candle.highPrice - candle.openingPrice : candle.highPrice - ticker.tradePrice
                } else {
                    partHeight = candle.openingPrice > candle.tradePrice ? candle.highPrice - candle.openingPrice : candle.highPrice - candle.tradePrice
                }
            case .bar:
                if candle.candleDateTimeKST == currentCandles.first?.candleDateTimeKST {
                    partHeight = candle.openingPrice > ticker.tradePrice ? candle.openingPrice - ticker.tradePrice : ticker.tradePrice - candle.openingPrice
                } else {
                    partHeight = candle.openingPrice > candle.tradePrice ? candle.openingPrice - candle.tradePrice : candle.tradePrice - candle.openingPrice
                }
            case .bottomTail:
                if candle.candleDateTimeKST == currentCandles.first?.candleDateTimeKST {
                    partHeight = candle.openingPrice > ticker.tradePrice ? ticker.tradePrice - candle.lowPrice : candle.openingPrice - candle.lowPrice
                } else {
                    partHeight = candle.openingPrice > candle.tradePrice ? candle.tradePrice - candle.lowPrice : candle.openingPrice - candle.lowPrice
                }
            case .bottomEmpty:
                partHeight = candle.lowPrice - groupLow
            }
            
            return partHeight / groupHeight
        }
        
        func changeCandleType(to: CandleType, code: String) {
            if to != currentCandleType {
                graphMoved = 0
                currentCandles = []
                requestCandles(code: code, type: to, count: "200")
                currentCandleType = to
            }
        }
    }
}
