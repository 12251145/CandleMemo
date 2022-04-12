//
//  NavBarPreferenceKeys.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/10.
//

import Foundation
import SwiftUI

struct NavBarTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct NavBarDatePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct NavBarCoinNamePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct NavBarPricePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

extension View {
    
    func navTitle(_ title: String) -> some View {
        preference(key: NavBarTitlePreferenceKey.self, value: title)
    }
    
    func navDate(_ date: String) -> some View {
        preference(key: NavBarDatePreferenceKey.self, value: date)
    }
    
    func coinName(_ name: String) -> some View {
        preference(key: NavBarCoinNamePreferenceKey.self, value: name)
    }
    
    func price(_ price: String) -> some View {
        preference(key: NavBarPricePreferenceKey.self, value: price)
    }
}
