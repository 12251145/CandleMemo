//
//  NavLink.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/10.
//

import SwiftUI

struct NavLink<Label: View, Destination: View>: View {
    
    let destination: Destination
    let label: Label
    
    init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
    }
    
    var body: some View {
        NavigationLink(destination:
                        NavBarContainerView(content: {
                            destination
                        }).navigationBarHidden(true)
                       , label: {
                            label
                        })
    }
}

struct NavLink_Previews: PreviewProvider {
    static var previews: some View {
        NavView {
            NavLink(destination: Text("Destination"), label: {
                Text("Navigate")
            })
        }
    }
}
