//
//  CandleChartView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/11.
//

import SwiftUI

struct CandleChartView: View {
    @StateObject private var viewModel = ViewModel()

    let market: Market
    let ticker: Ticker
    
    init(market: Market, ticker: Ticker) {
        self.market = market
        self.ticker = ticker
        print("CandleChartView init")
    }

    var body: some View {

        VStack(spacing: 0) {
            // 캔들 차트
            HStack(spacing: 1) {
                if !viewModel.currentCandles.isEmpty {
                    ForEach((viewModel.currentCandles)[viewModel.graphMoved..<viewModel.graphSize + viewModel.graphMoved].reversed()) { candle in
                        GeometryReader { proxy in
                            let size = proxy.size

                            VStack(alignment: .center, spacing: 0) {
                                
                                
                                
                                if candle.candleDateTimeKST == viewModel.currentCandles.first?.candleDateTimeKST {
                                    Rectangle()
                                        .fill(.clear)
                                        .frame(height: ((viewModel.groupHigh - candle.highPrice) / (viewModel.groupHigh - viewModel.groupLow)) * size.height)
                                    
                                    CandleShape(openingPrice: candle.openingPrice, tradePrice: ticker.tradePrice, highPrice: candle.highPrice, lowPrice: candle.lowPrice)
                                        .fill(candle.openingPrice > ticker.tradePrice ? .blue : .pink)
                                        .frame(height: ((candle.highPrice - candle.lowPrice) / (viewModel.groupHigh - viewModel.groupLow)) * size.height)
                                        .border(viewModel.currentCandles[viewModel.graphSize - Int(viewModel.sliderLocation) + viewModel.graphMoved].candleDateTimeKST == candle.candleDateTimeKST ? .white : .clear, width: 1)
                                    
                                    Rectangle()
                                        .fill(.clear)
                                        .frame(height: ((candle.lowPrice - viewModel.groupLow) / (viewModel.groupHigh - viewModel.groupLow)) * size.height)

                                        
                                } else {
                                    Rectangle()
                                        .fill(.clear)
                                        .frame(height: ((viewModel.groupHigh - candle.highPrice) / (viewModel.groupHigh - viewModel.groupLow)) * size.height)
                                    
                                    CandleShape(openingPrice: candle.openingPrice, tradePrice: candle.tradePrice, highPrice: candle.highPrice, lowPrice: candle.lowPrice)
                                        .fill(candle.openingPrice > candle.tradePrice ? .blue : .pink)
                                        .frame(height: ((candle.highPrice - candle.lowPrice) / (viewModel.groupHigh - viewModel.groupLow)) * size.height)
                                        .border(viewModel.currentCandles[viewModel.graphSize - Int(viewModel.sliderLocation) + viewModel.graphMoved].candleDateTimeKST == candle.candleDateTimeKST ? .white : .clear, width: 1)
                                    
                                    Rectangle()
                                        .fill(.clear)
                                        .frame(height: ((candle.lowPrice - viewModel.groupLow) / (viewModel.groupHigh - viewModel.groupLow)) * size.height)
                                    
                                }
                            }
                        }
                    }
                }
            }
            .frame(height: viewModel.candleChartHeight)
            .padding(.top, 15)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .padding(.horizontal, 30)
                    .gesture(
                        DragGesture()
                            .onChanged{ value in
                                if viewModel.ex != Int(value.translation.width / 7) {
                                    
                                    if viewModel.graphMoved + (Int(value.translation.width / 7) - viewModel.ex) < 0 {
                                        viewModel.graphMoved = 0
                                    } else if viewModel.graphSize >= viewModel.currentCandles.count - 1 {
                                        viewModel.graphMoved = 0
                                    } else if viewModel.graphMoved + viewModel.graphSize + (Int(value.translation.width / 7) - viewModel.ex) > viewModel.currentCandles.count - 1 {
                                        viewModel.graphMoved = viewModel.currentCandles.count - viewModel.graphSize
                                    } else {
                                        viewModel.graphMoved = viewModel.graphMoved + (Int(value.translation.width / 7) - viewModel.ex)
                                    }
                                    
                                    viewModel.ex = Int(value.translation.width) / 7
                                }
                            }
                            .onEnded{ value in
                                viewModel.ex = 0
                            }
                    )
                )

            Slider(value: $viewModel.sliderLocation, in: 1...Float(viewModel.graphSize), step: 1)
                .tint(Color.init(uiColor: .systemGray5))
                .padding(.horizontal, 15)
                .padding(.top, 10)
            
            HStack {
                Capsule()
                    .fill(Color.init(uiColor: .systemGray2))
                    .frame(width: 50, height: 5)
                    .padding(.vertical, 5)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .onAppear {
            viewModel.requestCandles(code: market.code, count: "200")
        }
        .sheet(isPresented: $viewModel.isShowingSheet) {
            Text("HI")
        }
    }
}


