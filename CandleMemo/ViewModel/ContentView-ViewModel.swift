//
//  ContentView-ViewModel.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/09.
//

import Foundation

extension ContentView {
    class ViewModel: ObservableObject {
        func cutKRW(from code: String) -> String {
            let startIndex: String.Index = code.index(code.startIndex, offsetBy: 4)
            
            return "\(code[startIndex...])"
        }
        
        
    }
}
