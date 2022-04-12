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
        ScrollView {
            VStack {
                CandleChartView(market: market)
            }
        }
        .navTitle(cutKRW(from: market.code))
        .coinName(market.koreanName)
        .price(priceFormat(upbitAPIController.tickers[market.code]?.trade_price ?? 0))
    }
}

