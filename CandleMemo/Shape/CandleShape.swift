//
//  CandleShape.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/18.
//

import SwiftUI

struct CandleShape: Shape {
    var openingPrice: CGFloat
    var tradePrice: CGFloat
    var highPrice: CGFloat
    var lowPrice: CGFloat

    private let tailWidth: CGFloat = 0.5
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        if openingPrice < tradePrice {
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX - tailWidth, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX - tailWidth, y: rect.maxY - ((openingPrice - lowPrice)/(highPrice - lowPrice)) * rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - ((openingPrice - lowPrice)/(highPrice - lowPrice)) * rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - ((tradePrice - lowPrice)/(highPrice - lowPrice)) * rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX - tailWidth, y: rect.maxY - ((tradePrice - lowPrice)/(highPrice - lowPrice)) * rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX - tailWidth, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX + tailWidth, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX + tailWidth, y: rect.maxY - ((tradePrice - lowPrice)/(highPrice - lowPrice)) * rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - ((tradePrice - lowPrice)/(highPrice - lowPrice)) * rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - ((openingPrice - lowPrice)/(highPrice - lowPrice)) * rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX + tailWidth, y: rect.maxY - ((openingPrice - lowPrice)/(highPrice - lowPrice)) * rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX + tailWidth, y: rect.maxY))
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        } else {
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX - tailWidth, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX - tailWidth, y: rect.maxY - ((tradePrice - lowPrice)/(highPrice - lowPrice)) * rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - ((tradePrice - lowPrice)/(highPrice - lowPrice)) * rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - ((openingPrice - lowPrice)/(highPrice - lowPrice)) * rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX - tailWidth, y: rect.maxY - ((openingPrice - lowPrice)/(highPrice - lowPrice)) * rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX - tailWidth, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX + tailWidth, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX + tailWidth, y: rect.maxY - ((openingPrice - lowPrice)/(highPrice - lowPrice)) * rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - ((openingPrice - lowPrice)/(highPrice - lowPrice)) * rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - ((tradePrice - lowPrice)/(highPrice - lowPrice)) * rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX + tailWidth, y: rect.maxY - ((tradePrice - lowPrice)/(highPrice - lowPrice)) * rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX + tailWidth, y: rect.maxY))
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
        
        
        return path
    }
}
