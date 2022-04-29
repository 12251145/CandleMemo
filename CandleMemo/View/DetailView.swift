//
//  DetailView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/11.
//

import SwiftUI

struct DetailView: View, FormatChanger {
    
    let market: Market
    let ticker: Ticker
    
    private let floatingButtonSize: CGFloat = 18
    private let floatingButtonMarginx: CGFloat = 40
    private let floatingButtonMarginy: CGFloat = 40
    private let floatingButtonMarginx2: CGFloat = 40
    private let floatingButtonMarginy2: CGFloat = 120
    
    init(market: Market, ticker: Ticker) {
        self.market = market
        self.ticker = ticker
        //print("DetailView init (\(market.code))")
    }
    
    var body: some View {
        
        GeometryReader { proxy in
            ZStack {
                VStack {
                    CandleChartView(market: market, ticker: ticker)
                }
            }
        }
        .navTitle(cutKRW(from: market.code))
        .coinName(market.koreanName)
        .price(priceFormat(ticker.tradePrice))
    }
}

