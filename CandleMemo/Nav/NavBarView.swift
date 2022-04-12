//
//  NavBarView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/10.
//

import SwiftUI

struct NavBarView: View {
    
    let title: String
    let date: String
    let coinName: String
    let price: String
    
    var body: some View {
        VStack(alignment: .leading) {
            titleSection
            dateSection
        }
        .padding(.horizontal)
        .padding(.bottom, 7)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.black)
    }
}

struct NavBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NavBarView(title: "코인", date: "6월 17일", coinName: "비트코인", price: "100")
            Spacer()
        }
    }
}

extension NavBarView {
    
    private var titleSection: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(coinName)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
        }
    }
    
    private var dateSection: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(date)
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.gray)
            
            Text(price)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
}
