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
                // 캔들 차트
                HStack(spacing: 1) {
                    if !viewModel.currentDisplayingCandles.isEmpty {
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
                                        .border(viewModel.currentDisplayingCandles[Int(viewModel.sliderLocation)].candleDateTimeKST == candle.candleDateTimeKST ? .white : .clear, width: 1)
                                    
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
                                    viewModel.chartScrollSubject.send(value.translation.width)
                                }
                                .onEnded{ _ in
                                    viewModel.lastGraphMoved = 0
                                }
                        )
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    viewModel.chartPinchSubject.send(value)
                                }
                                .onEnded { _ in
                                    viewModel.lastGraphSize = viewModel.graphSize                                
                                }
                        )
                    )
                
                
                // 가격 표시
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
            
            // 날짜 표시
            HStack {
                if !viewModel.currentDisplayingCandles.isEmpty {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(Color.init(uiColor: .systemGray6))
                            .frame(width: 100, height: 20)


                        Text("22-04-26")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding(.top, 10)
            
            HStack(spacing: 1) {
                // 캔들 선택 슬라이더
                Slider(value: $viewModel.sliderLocation, in: 0...(Float(viewModel.graphSize) - 1), step: 1)
                    .tint(Color.init(uiColor: .systemGray5))
                    .padding(.horizontal, 15)
                
                // 메모 추가 버튼
                Button {
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.init(uiColor: .systemGray6))
                            .frame(width: 40, height: 40)
                            .padding(5)
                        
                        Image(systemName: "plus")
                            .font(.title3)
                            .foregroundColor(Color.init(white: 0.9))
                        
                    }
                }
            }
            .padding(.top, 20)
            
            // 핸들
            HStack {
                Capsule()
                    .fill(Color.init(white: 0.9))
                    .frame(width: 50, height: 5)
                    .padding(.bottom, 5)
            }
            .frame(width: UIScreen.main.bounds.width, height: 25)
        }
        .onAppear {            
            viewModel.requestCandles(code: market.code, count: "200")
        }
        .onChange(of: CandleChartViewViewModel.ticker) { _ in
            viewModel.updateTicker()
        }
        
    }
}


