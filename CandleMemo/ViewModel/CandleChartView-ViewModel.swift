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
        @Published var graphMoved = 0 {
            didSet {
                groupHigh = getGroupHigh()
                groupLow = getGroupLow()
            }
        }
        @Published var ex = 0
        @Published var groupHigh: CGFloat = 1
        @Published var groupLow: CGFloat = 1
        @Published var sliderLocation: Float = 1
        @Published var isShowingSheet = false
        @Published var candleChartHeight = UIScreen.main.bounds.height * 0.35
        
        private let service = CandleChartService()

        private var cancellables = Set<AnyCancellable>()
        
        func requestCandles(code: String, to: String? = nil, count: String? = "200") {
            service.getCandles(from: code, to: to, count: count)
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
                    self?.sliderLocation = 1
                }
                .store(in: &cancellables)
        }
        
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
    }
}
