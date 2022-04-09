//
//  ContentView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/08.
//

import Combine
import SwiftUI

struct ContentView: View {
    @StateObject private var upbitAPIController = UpbitAPIController()
    @StateObject private var viewModel = ViewModel()
    
    let detector: CurrentValueSubject<CGFloat, Never>
    let publisher: AnyPublisher<CGFloat, Never>
    
    init() {
        let detector = CurrentValueSubject<CGFloat, Never>(0)

        self.publisher = detector
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .dropFirst()
            .eraseToAnyPublisher()
        
        self.detector = detector
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(upbitAPIController.krwMarkets, id: \.self) { market in
                        HStack() {
                            Text(viewModel.cutKRW(from: market.code))
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            
                            Text("\(upbitAPIController.tickers[market.code]?.trade_price ?? 0)")
                        }
                        Divider()
                    }
                }
                .background(
                    GeometryReader { proxy in
                        Color.clear.preference(key: ViewOffsetKey.self, value: -proxy.frame(in: .named("scroll")).origin.y)
                    }
                )
                .onPreferenceChange(ViewOffsetKey.self) {
                    upbitAPIController.isScrolliing = true
                    detector.send($0)
                }
            }
            .coordinateSpace(name: "scroll")
            .onReceive(publisher) { _ in
                upbitAPIController.isScrolliing = false
            }
            .toolbar {
                Button("연결") {
                    upbitAPIController.webSocketConnect()
                }
            }
        } 
    }
    
    struct ViewOffsetKey: PreferenceKey {
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value += nextValue()
        }
    }
}
