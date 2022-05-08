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
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - 차트
    private var graphMoved = 0 {
        didSet {
            groupHigh = getGroupHigh()
            groupLow = getGroupLow()
            currentDisplayingCandles = currentCandles[graphMoved..<graphSize + graphMoved].reversed()
        }
    }
    
    private var chartScrollBy: CGFloat = 7
    
    var lastGraphMoved = 0
    var lastGraphSize = 0
    var lastGraphZoomed: CGFloat = 1
    

    
    @Published var currentCandles: [Candle] = [] {
        didSet {
            if graphSize > currentCandles.count {
                graphSize = currentCandles.count
            }
            currentDisplayingCandles = currentCandles[graphMoved..<graphSize + graphMoved].reversed()
        }
    }
    @Published var graphSize = 40 {
        didSet {
            sliderLocation = min(sliderLocation, Float(graphSize - 1))
            groupHigh = getGroupHigh()
            groupLow = getGroupLow()
            currentDisplayingCandles = currentCandles[graphMoved..<graphSize + graphMoved].reversed()
        }
    }
    @Published var currentDisplayingCandles: [Candle] = []
    @Published var groupHigh: CGFloat = 1
    @Published var groupLow: CGFloat = 1
    @Published var sliderLocation: Float = 0
    @Published var candleChartHeight: CGFloat = 250
    
    // MARK: - Combine
    
    let chartScrollSubject: PassthroughSubject<CGFloat, Never>
    let chartScrollPublisher: AnyPublisher<CGFloat, Never>
    
    let chartPinchSubject: PassthroughSubject<CGFloat, Never>
    let chartPinchPublisher: AnyPublisher<CGFloat, Never>
    
    init() {
        // 스크롤
        let chartScrollSubject = PassthroughSubject<CGFloat, Never>()
        
        self.chartScrollPublisher = chartScrollSubject
            .eraseToAnyPublisher()
        
        self.chartScrollSubject = chartScrollSubject
        
        // 핀치
        let chartPinchSubject = PassthroughSubject<CGFloat, Never>()
        
        self.chartPinchPublisher = chartPinchSubject
            .eraseToAnyPublisher()
        
        self.chartPinchSubject = chartPinchSubject
                
        // 구독
        chartScrollPublisher
            .sink { value in
                if self.lastGraphMoved != Int(value / self.chartScrollBy) {
                
                    if self.graphMoved + (Int(value / self.chartScrollBy) - self.lastGraphMoved) < 0 {
                        self.graphMoved = 0
                    } else if self.graphSize >= self.currentCandles.count - 1 {
                        self.graphMoved = 0
                    } else if self.graphMoved + self.graphSize + (Int(value / self.chartScrollBy) - self.lastGraphMoved) > self.currentCandles.count - 1 {
                        self.graphMoved = self.currentCandles.count - self.graphSize
                    } else {
                        self.graphMoved = self.graphMoved + (Int(value / self.chartScrollBy) - self.lastGraphMoved)
                    }
                    
                    
                    self.lastGraphMoved = Int(value) / Int(self.chartScrollBy)
                }
            }
            .store(in: &subscriptions)
        
        chartPinchPublisher
            .sink { value in
                
                withAnimation(Animation.linear(duration: 0.05)) {
                    if self.graphSize >= 25 {
                        if value > 1 {
                            let gentleValue = ((value - 1) / 7) + 1
                            self.graphSize = max(Int(CGFloat(self.lastGraphSize) * (2 - gentleValue)), min(self.currentCandles.count, 25))
                        } else {
                            self.graphSize = min(min(Int(CGFloat(self.lastGraphSize) * (2 - value)), 100), self.currentCandles.count - self.graphMoved)
                        }
                    }
                }
                
                self.lastGraphZoomed = value
            }
            .store(in: &subscriptions)
        
        //
        self.lastGraphSize = self.graphSize
    }
    
    
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
            .store(in: &subscriptions)
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
