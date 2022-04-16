//
//  CandleChartView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/11.
//

import SwiftUI

enum CandlePart {
    case topEmpty
    case topTail
    case bar
    case bottomTail
    case bottomEmpty
}

struct CandleChartView: View {
    @StateObject private var viewModel = ViewModel()

    let market: Market
    let ticker: Ticker

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    Spacer()
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            viewModel.changeCandleType(to: .day, code: market.code)
                        }
                    } label: {
                        Text("1일")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .padding(9)
                            .background(
                                viewModel.currentCandleType == .day ? Color.init(uiColor: .systemGray5) : .clear
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            
                    }
                    
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            viewModel.changeCandleType(to: .week, code: market.code)
                        }
                    } label: {
                        Text("1주")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .padding(9)
                            .background(
                                viewModel.currentCandleType == .week ? Color.init(uiColor: .systemGray5) : .clear
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            viewModel.changeCandleType(to: .month, code: market.code)
                        }
                    } label: {
                        Text("1달")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .padding(9)
                            .background(
                                viewModel.currentCandleType == .month ? Color.init(uiColor: .systemGray5) : .clear
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    
                }
                .padding(.bottom, 10)
                .padding(.horizontal)
        
                
                HStack(spacing: 1) {
                    if !viewModel.currentCandles.isEmpty {

                        ForEach((viewModel.currentCandles)[0 + viewModel.graphMoved..<viewModel.graphSize + viewModel.graphMoved].reversed()) { candle in
                            
                            GeometryReader { geo in
                                VStack(spacing: 0) {
                                    
                                    RoundedRectangle(cornerRadius: 1)
                                        .fill(.clear)
                                        .frame(height: viewModel.getHeight(part: .topEmpty, graphSize: viewModel.graphSize, graphMoved: viewModel.graphMoved, candle: candle, code: candle.code, ticker: ticker)
                                               * geo.size.height)
                                    
                                    RoundedRectangle(cornerRadius: 0)
                                        .fill(candle.candleDateTimeKST == viewModel.currentCandles.first?.candleDateTimeKST ? (ticker.openingPrice < ticker.tradePrice ? .pink : .blue) : (candle.openingPrice < candle.tradePrice ? .pink : .blue))
                                        .frame(width: 2, height: viewModel.getHeight(part: .topTail, graphSize: viewModel.graphSize, graphMoved: viewModel.graphMoved, candle: candle, code: candle.code, ticker: ticker)
                                               * geo.size.height)
                                
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 1)
                                            .fill(candle.candleDateTimeKST == viewModel.currentCandles.first?.candleDateTimeKST ? (ticker.openingPrice < ticker.tradePrice ? .pink : .blue) : (candle.openingPrice < candle.tradePrice ? .pink : .blue))
                                            .frame(height: viewModel.getHeight(part: .bar, graphSize: viewModel.graphSize, graphMoved: viewModel.graphMoved, candle: candle, code: candle.code, ticker: ticker)
                                                   * geo.size.height)
                                        
                                        RoundedRectangle(cornerRadius: 1)
                                            .fill(candle.candleDateTimeKST == viewModel.currentCandles.first?.candleDateTimeKST ? (ticker.openingPrice < ticker.tradePrice ? .pink : .blue) : (candle.openingPrice < candle.tradePrice ? .pink : .blue))
                                            .frame(height: 1)
                                    }
                                    
                                    RoundedRectangle(cornerRadius: 0)
                                        .fill(candle.candleDateTimeKST == viewModel.currentCandles.first?.candleDateTimeKST ? (ticker.openingPrice < ticker.tradePrice ? .pink : .blue) : (candle.openingPrice < candle.tradePrice ? .pink : .blue))
                                        .frame(width: 2, height: viewModel.getHeight(part: .bottomTail, graphSize: viewModel.graphSize, graphMoved: viewModel.graphMoved, candle: candle, code: candle.code, ticker: ticker)
                                               * geo.size.height)
                                
                                    RoundedRectangle(cornerRadius: 1)
                                        .fill(.clear)
                                        .frame(height: viewModel.getHeight(part: .bottomEmpty, graphSize: viewModel.graphSize, graphMoved: viewModel.graphMoved, candle: candle, code: candle.code, ticker: ticker)
                                               * geo.size.height)
                                }
                            }
                        }
                        
                    }
                }
                .frame(width: size.width, height: UIScreen.main.bounds.height * 0.35)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .fill(.black)
                        .padding(.horizontal, 30)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    print("Dragging")
                                })
                        )
                        
                )
                
                // Picker 만들어야 함.
            }
            
        }
        .onAppear {
            viewModel.requestCandles(code: market.code, type: viewModel.currentCandleType, count: "200")
        }
    }
}


