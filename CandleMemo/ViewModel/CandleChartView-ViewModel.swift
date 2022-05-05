//
//  CandleChartView-ViewModel.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/14.
//

import Combine
import Foundation
import SwiftUI

protocol CandleChartViewModelProtocol {
    func getCandles(from: String,to: String?, count: String?) -> AnyPublisher<[Candle], RequestError>
}

protocol CandleChartManagerProtocol {
    func getGroupHigh() -> CGFloat
    func getGroupLow() -> CGFloat
    func updateTicker()
}

class CandleChartViewViewModel: HTTPClient, ObservableObject {
    static var ticker: Ticker?
    
    var graphMoved = 0 {
        didSet {
            groupHigh = getGroupHigh()
            groupLow = getGroupLow()
            currentDisplayingCandles = currentCandles[graphMoved..<graphSize + graphMoved].reversed()
        }
    }
    
    var ex = 0
    
    @Published var currentCandles: [Candle] = [] {
        didSet {
            currentDisplayingCandles = currentCandles[graphMoved..<graphSize + graphMoved].reversed()
        }
    }
    @Published var currentDisplayingCandles: [Candle] = []
    @Published var graphSize = 70
    @Published var groupHigh: CGFloat = 1
    @Published var groupLow: CGFloat = 1
    @Published var sliderLocation: Float = 0
    @Published var candleChartHeight = UIScreen.main.bounds.height * 0.27
    
    init() {
        print("init viewModel")
    }
    
    
    private var cancellables = Set<AnyCancellable>()
    
    func requestCandles(code: String, to: String? = nil, count: String? = "200") {
        getCandles(from: code, to: to, count: count)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("get all candles!")
                case .failure(let error):
                    print(error.customMessage)
                }
            } receiveValue: { [weak self] candles in
                self?.currentCandles = candles + (self?.currentCandles ?? [])
                
                self?.graphSize = self?.graphSize ?? 0 < (self?.currentCandles.count ?? 0) ? self?.graphSize ?? 0 : (self?.currentCandles.count ?? 0)
                self?.groupHigh = self?.getGroupHigh() ?? 1
                self?.groupLow = self?.getGroupLow() ?? 1
                
                self?.sliderLocation = 0
            }
            .store(in: &cancellables)
    }
}

extension CandleChartViewViewModel: CandleChartManagerProtocol {
    
    func getGroupHigh() -> CGFloat {
        if currentCandles.isEmpty { return 1 }
        
        let checkSize = currentCandles.count < graphSize ? currentCandles.count : graphSize + graphMoved
        var max = currentCandles[graphMoved].highPrice
        
        for i in graphMoved..<checkSize {
            max = max < currentCandles[i].highPrice ? currentCandles[i].highPrice : max
        }
        
        return max
    }
    
    func getGroupLow() -> CGFloat {
        if currentCandles.isEmpty { return 1 }
        
        let checkSize = currentCandles.count < graphSize ? currentCandles.count : graphSize + graphMoved
        var min = currentCandles[graphMoved].lowPrice
        
        for i in graphMoved..<checkSize {
            min = min > currentCandles[i].lowPrice ? currentCandles[i].lowPrice : min
        }
        
        return min
    }
    
    func updateTicker() {
        if !currentCandles.isEmpty {
            currentCandles[0].openingPrice = CandleChartViewViewModel.ticker?.openingPrice ?? 0
            currentCandles[0].highPrice = CandleChartViewViewModel.ticker?.highPrice ?? 0
            currentCandles[0].tradePrice = CandleChartViewViewModel.ticker?.tradePrice ?? 0
            currentCandles[0].lowPrice = CandleChartViewViewModel.ticker?.lowPrice ?? 0
        }
    }
}

extension CandleChartViewViewModel: CandleChartViewModelProtocol {
    func getCandles(from: String,to: String?, count: String?) -> AnyPublisher<[Candle], RequestError> {
        return sendRequest(endpoint: UpbitEndpoint.candles(market: from, to: to, count: count))
    }
}

extension CandleChartViewViewModel: FormatChanger { }
