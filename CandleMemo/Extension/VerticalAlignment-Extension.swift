//
//  VerticalAlignment-Extension.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/10.
//

import Foundation
import SwiftUI

extension VerticalAlignment {
    
    enum CodePriceAlignment: AlignmentID {
        
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.top]
        }
    }

    
    static let codePriceAlignmnet = VerticalAlignment(CodePriceAlignment.self)
}
