//
//  NavBarContainerView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/10.
//

import SwiftUI

struct NavBarContainerView<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            NavBarView()
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct NavBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        NavBarContainerView {
            Color.pink
                .ignoresSafeArea()
        }
    }
}
