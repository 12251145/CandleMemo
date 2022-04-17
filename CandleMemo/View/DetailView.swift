//
//  DetailView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/11.
//

import SwiftUI

struct DetailView: View, FormatChanger {
    @EnvironmentObject private var upbitAPIController : UpbitAPIController
    
    let market: Market
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {

            VStack {
                if upbitAPIController.tickers[market.code] != nil {
                    CandleChartView(market: market, ticker: upbitAPIController.tickers[market.code]!)
                }
            }
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(key: ViewOffsetKey.self, value: -proxy.frame(in: .named("detailScroll")).origin.y)
                }
            )
            .onPreferenceChange(ViewOffsetKey.self) {
                upbitAPIController.pausePublishTickers()
                upbitAPIController.finishDetector.send($0)
            }
        }
        .navTitle(cutKRW(from: market.code))
        .coinName(market.koreanName)
        .price(priceFormat(upbitAPIController.tickers[market.code]?.tradePrice ?? 0))
        .coordinateSpace(name: "detailScroll")
        .onReceive(upbitAPIController.finishPublisher) { _ in
            upbitAPIController.resumePublishTickers()
        }
    }
}

