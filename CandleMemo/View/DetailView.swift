//
//  DetailView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/05/01.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel = DetailViewViewModel()
    
    let market: Market
    let ticker: Ticker
    
    var body: some View {
        VStack(spacing: 0) {            
            CandleChartView(market: market, ticker: ticker)
            
            Rectangle()
                .fill(Color.init(uiColor: .systemGray6))
                .frame(width: UIScreen.main.bounds.width, height: 1)         
        
            List(0..<10, id: \.self) { _ in
                Button {
                    
                } label: {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("제목이 온다.")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.init(uiColor: .systemGray6))
                            )
                        
                        HStack(alignment: .firstTextBaseline) {
                            Text("2022년 04월 31일")
                                .foregroundColor(Color.init(uiColor: .systemGray2))
                                .fontWeight(.bold)
                            
                            Text("아 이때 팔걸 아 이때 팔걸 아 이때 팔걸 아 이때 팔걸")
                                .font(.caption)
                                .lineLimit(1)
                        }
                    }
                }
                .padding(.vertical, 10)
                .listRowSeparator(.hidden)
                
            }
            .listStyle(.plain)
        }
        .navTitle(viewModel.cutKRW(from: market.code))
        .coinName(market.koreanName)
        .price(viewModel.priceFormat(ticker.tradePrice))
    }
}


