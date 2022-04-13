//
//  CandleMemoApp.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/08.
//

import SwiftUI

@main
struct CandleMemoApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var upbitAPIController = UpbitAPIController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(upbitAPIController)
                .preferredColorScheme(.dark)
                .onChange(of: scenePhase) { newValue in
                    if newValue == .inactive || newValue == .background {
                        upbitAPIController.webSocketDisconnect()
                    }
                    
                    if newValue == .active {
                        upbitAPIController.webSocketConnect()
                    }
                }
        }
    }
}
