//
//  CandleChartView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/11.
//

import SwiftUI

struct CandleChartView: View {
    @StateObject private var viewModel = CandleChartViewViewModel()

    let market: Market
    let ticker: Ticker
    
    init(market: Market, ticker: Ticker) {
        self.market = market
        self.ticker = ticker
        
        CandleChartViewViewModel.ticker = ticker
        
        print("CandleChartView init")
    }

    var body: some View {

        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 1) {
                HStack(spacing: 1) {
                    if !viewModel.currentCandles.isEmpty {
                        ForEach(viewModel.currentDisplayingCandles) { candle in
                            GeometryReader { proxy in
                                let size = proxy.size

                                VStack(alignment: .center, spacing: 0) {
                                    
                                    
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
                .frame(height: viewModel.candleChartHeight)
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
                
                ZStack {
                    if !viewModel.currentDisplayingCandles.isEmpty {
                        GeometryReader { proxy in
                            let size = proxy.size
                            
                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(height: 0)
                            
                                ZStack {
                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                                        .fill(.white)
                                        .frame(width: 50, height: 16)
                                        
                                    HStack(spacing: 0) {
                                        Text(viewModel.noFractionDigits(viewModel.groupHigh))
                                            .font(.system(size: 10))
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 2)
                                }
                                .offset(y: -8)
                                    
                            }
                            
                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(height: size.height )
                            
                                
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                                        .fill(.white)
                                        .frame(width: 50, height: 16)
                                        
                                    HStack {
                                        Text(viewModel.noFractionDigits(viewModel.groupLow))
                                            .font(.system(size: 10))
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                            
                                    }
                                    .padding(.horizontal, 2)
                                }
                                .offset(y: -8)
                                    
                            }
                            
                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(height: ((viewModel.groupHigh - (viewModel.currentDisplayingCandles.last?.tradePrice ?? 0)) / (viewModel.groupHigh - viewModel.groupLow)) * size.height)
                                
                                
                                
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                                        .fill((viewModel.currentDisplayingCandles.last?.tradePrice ?? 0) - (viewModel.currentDisplayingCandles.last?.openingPrice ?? 0) < 0 ? .blue : .pink)
                                        .frame(width: 50, height: 16)
                                        
                                        
                                    HStack {
                                        Text(viewModel.noFractionDigits(viewModel.currentDisplayingCandles.last?.tradePrice ?? 0))
                                            .font(.system(size: 10))
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                    }
                                    .padding(.horizontal, 2)
                                }
                                .offset(y: -8)
                            }
                        }
                    }
                }
                .frame(width: 50, height: viewModel.candleChartHeight)
            }

            Slider(value: $viewModel.sliderLocation, in: 1...Float(viewModel.graphSize), step: 1)
                .tint(Color.init(uiColor: .systemGray5))
                .padding(.horizontal, 15)
                .padding(.top, 10)
        }
        .padding(.top, 15)
        .onAppear {            
            viewModel.requestCandles(code: market.code, count: "200")
        }
        .onChange(of: CandleChartViewViewModel.ticker) { _ in
            viewModel.updateTicker()
        }
    }
}


