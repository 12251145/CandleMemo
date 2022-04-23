//
//  ContentView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/08.
//

import Combine
import SwiftUI

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var viewModel = ContentViewViewModel()
    
    init(){
        print("ContentView init")
    }
    
    var body: some View {
        NavView {
            defaultView
                .navTitle("코인")
                .navDate("6월 17일")
        }
        .environmentObject(viewModel)
        .onAppear {
            viewModel.requestKRWMarkets()
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                viewModel.webSocketConnect()
            }
        }
    }
}

extension ContentView {
    private var defaultView: some View {
        ScrollView {
            LazyVStack {
                ZStack {
                    Divider()
                }
                .padding(.leading)
                
                ForEach(viewModel.krwMarkets, id: \.self) { market in
                    
                    if viewModel.tickers[market.code] != nil {
                        CoinCellView(market: market, ticker: viewModel.tickers[market.code]!)
                            .background(
                                NavLink(destination: DetailView(market: market, ticker: viewModel.tickers[market.code]!), label: {
                                    RoundedRectangle(cornerRadius: 1, style: .continuous)
                                        .fill(.clear)
                                })
                            )
                    }
                }
            }
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(key: ViewOffsetKey.self, value: -proxy.frame(in: .named("contentScroll")).origin.y)
                }
            )
            .onPreferenceChange(ViewOffsetKey.self) {
                viewModel.pausePublishTickers()
                viewModel.finishDetector.send($0)
            }
        }
        .coordinateSpace(name: "contentScroll")
        .onReceive(viewModel.finishPublisher) { _ in
            viewModel.resumePublishTickers()
        }
    }
}
