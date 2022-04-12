//
//  NavBarContainerView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/10.
//

import SwiftUI

struct NavBarContainerView<Content: View>: View {
    
    let content: Content
    
    @State private var title: String = ""
    @State private var date: String = ""
    @State private var coinName: String = ""
    @State private var price: String = ""
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            NavBarView(title: title, date: date, coinName: coinName, price: price)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onPreferenceChange(NavBarTitlePreferenceKey.self) { value in
            self.title = value
        }
        .onPreferenceChange(NavBarDatePreferenceKey.self) { value in
            self.date = value
        }
        .onPreferenceChange(NavBarCoinNamePreferenceKey.self) { value in
            self.coinName = value
        }
        .onPreferenceChange(NavBarPricePreferenceKey.self) { value in
            self.price = value
        }
        
    }
}

struct NavBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        NavBarContainerView {
            Color.pink
                .ignoresSafeArea()
                .navTitle("코인")
                //.navDate("6월 17일")
                .coinName("비트코인")
                .price("1000")
        }
    }
}
