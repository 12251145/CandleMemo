//
//  NavView.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/10.
//

import SwiftUI

struct NavView<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            NavBarContainerView {
                content
            }
            .navigationBarHidden(true)
        }        
    }
}

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        NavView {
            Color.pink
                .ignoresSafeArea()
        }
    }
}

extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = nil
    }
}
