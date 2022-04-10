//
//  Market.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/09.
//

import Foundation

struct Market: Codable, Hashable {
    let code: String
    let koreanName: String
    let englishName: String

    
    enum CodingKeys: String, CodingKey {
        case code = "market"
        case koreanName = "korean_name"
        case englishName = "english_name"
    }
}
