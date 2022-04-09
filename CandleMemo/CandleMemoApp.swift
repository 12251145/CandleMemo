//
//  CandleMemoApp.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/08.
//

import SwiftUI

@main
struct CandleMemoApp: App {
    //@StateObject private var upbitAPIController = UpbitAPIController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                //.environmentObject(upbitAPIController)
                .preferredColorScheme(.dark)
        }
    }
}
