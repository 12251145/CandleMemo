//
//  ContentView-ViewModel.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/09.
//

import Combine
import SwiftUI

extension ContentView {
    class ViewModel: ObservableObject {
        
        let finishDetector: CurrentValueSubject<CGFloat, Never>
        let finishPublisher: AnyPublisher<CGFloat, Never>
        
        init() {
            let finishDetector = CurrentValueSubject<CGFloat, Never>(0)
            
            self.finishPublisher = finishDetector
                .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
            
            self.finishDetector = finishDetector
        }
        
        func cutKRW(from code: String) -> String {
            let startIndex: String.Index = code.index(code.startIndex, offsetBy: 4)
            
            return "\(code[startIndex...])"
        }
    }
}
