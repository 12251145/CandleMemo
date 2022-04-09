//
//  ContentView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/08.
//

import Combine
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var upbitAPIController: UpbitAPIController
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ZStack {
                        Divider()
                    }
                    .padding(.leading)
                    
                    ForEach(upbitAPIController.krwMarkets, id: \.self) { market in
                        HStack() {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(viewModel.cutKRW(from: market.code))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text(market.koreanName)
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 5) {
                                Text(viewModel.priceFormat(upbitAPIController.tickers[market.code]?.trade_price ?? 0))
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                HStack(alignment: .center) {
                                    Spacer()
                                    Text(viewModel.rateFormat(upbitAPIController.tickers[market.code]?.signed_change_rate ?? 0))
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 5)
                                }
                                .frame(width: 70, height: 25)
                                .background(
                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                                        .fill(upbitAPIController.tickers[market.code]?.change ?? "EVEN" == "RISE" ? .red : .green)
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        ZStack {
                            Divider()
                        }
                        .padding(.leading)
                    }
                }
                .background(
                    GeometryReader { proxy in
                        Color.clear.preference(key: ViewOffsetKey.self, value: -proxy.frame(in: .named("scroll")).origin.y)
                    }
                )
                .onPreferenceChange(ViewOffsetKey.self) {
                    upbitAPIController.isScrolliing = true
                    viewModel.finishDetector.send($0)
                }
            }
            .coordinateSpace(name: "scroll")
            .onReceive(viewModel.finishPublisher) { _ in
                upbitAPIController.isScrolliing = false
            }
            .toolbar {
                Button("연결") {
                    upbitAPIController.webSocketConnect()
                }
            }
        } 
    }
    
    struct ViewOffsetKey: PreferenceKey {
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value += nextValue()
        }
    }
}
