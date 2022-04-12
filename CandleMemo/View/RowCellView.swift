//
//  RowCellView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/10.
//

import SwiftUI

struct RowCellView: View, FormatChanger {
    @EnvironmentObject private var upbitAPIController: UpbitAPIController
    
    let market: Market
    
    var body: some View {
        VStack(spacing: 3) {
            HStack(alignment: .firstTextBaseline) {
                Text(cutKRW(from: market.code))
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()
                
                Text(priceFormat(upbitAPIController.tickers[market.code]?.trade_price ?? 0))
                    .font(.title3)
                    .fontWeight(.semibold)

            }
            

            HStack(alignment: .firstTextBaseline) {
                Text(market.koreanName)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)

                Spacer()
                
                Text(rateFormat(upbitAPIController.tickers[market.code]?.signed_change_rate ?? 0))
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 5)
                    .frame(width: 75, height: 25, alignment: .trailing)
                    .background(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(upbitAPIController.tickers[market.code]?.change ?? "EVEN" == "RISE" ? .pink : .blue)
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        
        
        ZStack {
            Divider()
        }
        .padding(.leading)
    }
}
