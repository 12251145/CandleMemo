//
//  CandleChartView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/11.
//

import SwiftUI

struct CandleChartView: View {
    // market 정보 받아야함.
    // 과거 데이터 받아와야 함.
    // 실시간 가격 반영해서 그래프 그려야 함.
    @EnvironmentObject private var upbitAPIController: UpbitAPIController
    
    let market: Market
    
    var body: some View {
        HStack {
            Button("테스트") {
                upbitAPIController.requestCandels(code: "KRW-BTC", type: .week)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
