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
    // 일, 주, 달 버튼 만들고 터치하면 그래프 변해야 함
    // 캔들 선택할 수 있게 만들고 메모 추가 할 수 있게 해야함.
    // 메모는 Core Data 및 Cloudkit에 저장하고 그래프 그릴 때 반영해야 함.
    
    //
    @EnvironmentObject private var upbitAPIController: UpbitAPIController
    
    let market: Market

    @State private var graphSize = 20
    @State private var graphMoved = 0
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            HStack(spacing: 1) {
                ForEach((upbitAPIController.candles[market.code] ?? Array(repeating: Candle.dummy, count: graphSize))[
                    0 + graphMoved..<graphSize + graphMoved
                ].reversed(), id: \.self) { candle in
                    VStack(spacing: 0) {
                        GeometryReader { geo in
                            RoundedRectangle(cornerRadius: 3)
                                .fill(.blue)
                        }
                        
                        GeometryReader { geo in
                            RoundedRectangle(cornerRadius: 3)
                                .fill(.green)
                        }
                        
                        GeometryReader { geo in
                            RoundedRectangle(cornerRadius: 3)
                                .fill(.indigo)
                        }
                    }
                }
            }
            .frame(width: size.width, height: UIScreen.main.bounds.height * 0.4)
            .background(.red)
            
        }
        .onAppear {
            upbitAPIController.requestCandles(code: market.code, type: .day, count: "50")
        }
    }
}
