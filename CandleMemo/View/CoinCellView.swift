//
//  RowCellView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/10.
//

import SwiftUI

struct CoinCellView: View, FormatChanger {
    let market: Market
    let ticker: Ticker
    
    init(market: Market, ticker: Ticker) {
        self.market = market
        self.ticker = ticker
        //print("RowCellView init (\(market.code))")
    }
    
    
    var body: some View {
        HStack(spacing: 5) {
            CandleShape(openingPrice: ticker.openingPrice, tradePrice: ticker.tradePrice, highPrice: ticker.highPrice, lowPrice: ticker.lowPrice)
                .fill(ticker.openingPrice < ticker.tradePrice ? .pink : .blue)
                .frame(width: 8, height: 35)
                
            
            VStack(spacing: 5) {
                HStack(alignment: .firstTextBaseline) {
                    Text(cutKRW(from: market.code))
                        .font(.title3)
                        .fontWeight(.bold)

                    Spacer()
                    
                    Text(priceFormat(ticker.tradePrice))
                        .font(.title3)
                        .fontWeight(.semibold)

                }
                

                HStack(alignment: .firstTextBaseline) {
                    Text(market.koreanName)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)

                    Spacer()
                    
                    Text(rateFormat(ticker.signedChangeRate))
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 5)
                        .frame(width: 75, height: 25, alignment: .trailing)
                        .background(
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(ticker.change == "RISE" ? .pink : .blue)
                        )
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        
        
        ZStack {
            Divider()
        }
        .padding(.leading)
    }
}
