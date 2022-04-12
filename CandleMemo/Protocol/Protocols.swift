//
//  Protocols.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/12.
//

import Foundation

protocol FormatChanger {
    func cutKRW(from code: String) -> String
    
    func priceFormat(_ price: Double) -> String
    
    func rateFormat(_ number: Double) -> String
}

extension FormatChanger {
    func cutKRW(from code: String) -> String {
        let startIndex: String.Index = code.index(code.startIndex, offsetBy: 4)
        
        return "\(code[startIndex...])"
    }
    
    func priceFormat(_ price: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        return numberFormatter.string(for: price)!
    }
    
    func rateFormat(_ number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        return numberFormatter.string(for: number)!
    }
}
