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
    @EnvironmentObject private var upbitAPIController: UpbitAPIController
    
    var body: some View {
        NavView {
            defaultView
                .navTitle("코인")
                .navDate("6월 17일")
        }
        .onAppear {
            upbitAPIController.requestKRWMarkets()
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
                
                ForEach(upbitAPIController.krwMarkets, id: \.self) { market in
                    
                    RowCellView(market: market)
                        .background(
                            NavLink(destination: DetailView(market: market)
                            
                                        , label: {
                                    RoundedRectangle(cornerRadius: 1, style: .continuous)
                                        .fill(.clear)
                            })
                        )
                    
                }
                
            }
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(key: ViewOffsetKey.self, value: -proxy.frame(in: .named("contentScroll")).origin.y)
                }
            )
            .onPreferenceChange(ViewOffsetKey.self) {
                upbitAPIController.pausePublishTickers()
                upbitAPIController.finishDetector.send($0)
            }
        }
        .coordinateSpace(name: "contentScroll")
        .onReceive(upbitAPIController.finishPublisher) { _ in
            upbitAPIController.resumePublishTickers()
        }
    }
}
