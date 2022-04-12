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
    }
}
