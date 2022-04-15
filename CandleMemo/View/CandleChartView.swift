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
    let tradePrice: Double

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            HStack(spacing: 1) {
                if !viewModel.currentCandles.isEmpty {

                    ForEach((viewModel.currentCandles)[0 + viewModel.graphMoved..<viewModel.graphSize + viewModel.graphMoved].reversed()) { candle in
                        
                        GeometryReader { geo in
                            VStack(spacing: 0) {
                                
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(.clear)
                                    .frame(height: viewModel.getHeight(part: .topEmpty, graphSize: viewModel.graphSize, graphMoved: viewModel.graphMoved, candle: candle, code: candle.code)
                                           * geo.size.height)
                                
                                RoundedRectangle(cornerRadius: 0)
                                    .fill(candle.openingPrice < candle.tradePrice ? .pink : .blue)
                                    .frame(width: 2, height: viewModel.getHeight(part: .topTail, graphSize: viewModel.graphSize, graphMoved: viewModel.graphMoved, candle: candle, code: candle.code, tradePrice: tradePrice)
                                           * geo.size.height)
                            
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(candle.openingPrice < candle.tradePrice ? .pink : .blue)
                                    .frame(height: viewModel.getHeight(part: .bar, graphSize: viewModel.graphSize, graphMoved: viewModel.graphMoved, candle: candle, code: candle.code, tradePrice: tradePrice)
                                           * geo.size.height)
                                
                                RoundedRectangle(cornerRadius: 0)
                                    .fill(candle.openingPrice < candle.tradePrice ? .pink : .blue)
                                    .frame(width: 2, height: viewModel.getHeight(part: .bottomTail, graphSize: viewModel.graphSize, graphMoved: viewModel.graphMoved, candle: candle, code: candle.code, tradePrice: tradePrice)
                                           * geo.size.height)
                            
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(.clear)
                                    .frame(height: viewModel.getHeight(part: .bottomEmpty, graphSize: viewModel.graphSize, graphMoved: viewModel.graphMoved, candle: candle, code: candle.code)
                                           * geo.size.height)
                            }
                        }
                    }
                    
                }
            }
            .frame(width: size.width, height: UIScreen.main.bounds.height * 0.4)
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
            
        }
        .onAppear {
            viewModel.requestCandles(code: market.code, type: .day, count: "200")
        }
    }
}


