//
//  FloatinActionButton.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/18.
//

import SwiftUI

struct FloatingActionButton<ImageView: View>: ViewModifier {
    let color: Color
    let image: ImageView
    let action: () -> ()
    
    private let size: CGFloat = 60
    private let margin: CGFloat = 15
    
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            ZStack {
                Color.clear
                content
                button(proxy)
            }
        }
    }
    
    
    @ViewBuilder private func button(_ proxy: GeometryProxy) -> some View {
        image
            .imageScale(.large)
            .frame(width: size, height: size)
            .background(Circle().fill(color))
            .onTapGesture(perform: action)
            .offset(x: (proxy.size.width - size) / 2 - margin,
                    y: (proxy.size.height - size) / 2 - margin)
    }
}

extension View {
    func floatingActionButton<ImageView: View>(
        color: Color,
        image: ImageView,
        action: @escaping () -> ()) -> some View {
            self.modifier(FloatingActionButton(color: color, image: image, action: action))
    }
}
