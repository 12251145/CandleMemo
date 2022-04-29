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
                    
                    List {
                        ForEach(0...10, id: \.self) { i in
                            Button {
                                
                            } label: {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("🤯")
                                        .font(.title2)
                                    HStack(alignment: .firstTextBaseline) {
                                        Text("2022/4/18 월")
                                            .fontWeight(.semibold)
                                        
                                        Text("나는 망했다!!나는 망했다!!나는 망했다!!나는 망했다!!나는 망했다!!나는 망했다!!나는 망했다!!나는 망했다!!나는 망했다!!나는 망했다!!")
                                            .font(.caption)
                                            .lineLimit(1)
                                            
                                    }
                                }
                                .padding(.vertical, 10)
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    
                }
                
                Button{
                    
                } label: {
                    ZStack {
                        Circle()
                            .fill(.green)
                            .frame(width: 60, height: 60)
                            
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
                .offset(x: (proxy.size.width - floatingButtonSize) / 2 - floatingButtonMarginx,
                        y: (proxy.size.height - floatingButtonSize) / 2 - floatingButtonMarginy)
                
                Button{
                    
                } label: {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 60, height: 60)
                    
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
                .offset(x: (proxy.size.width - floatingButtonSize) / 2 - floatingButtonMarginx2,
                        y: (proxy.size.height - floatingButtonSize) / 2 - floatingButtonMarginy2)
            }
        }
        .navTitle(cutKRW(from: market.code))
        .coinName(market.koreanName)
        .price(priceFormat(ticker.tradePrice))
        
    }
}

