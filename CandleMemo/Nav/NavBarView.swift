//
//  NavBarView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/10.
//

import SwiftUI

struct NavBarView: View {
    @State private var date: String = "6월 17일"
    
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
            NavBarView()
            Spacer()
        }
    }
}

extension NavBarView {
    
    private var titleSection: some View {
        Text("코인")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
    }
    
    private var dateSection: some View {
        Text(date)
            .font(.title)
            .fontWeight(.heavy)
            .foregroundColor(.gray)
    }
}
