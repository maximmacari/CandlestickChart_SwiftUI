//
//  CandleView.swift
//  CandlestickChart
//
//  Created by Maxim Macari on 28/3/21.
//

import SwiftUI

struct CandleView: View {
    
    var candleNormalized: HistoricalData
    @State var rect = CGRect.zero
    
    var smaller: Double {
        return min(candleNormalized.open, candleNormalized.close)
    }

    // if its green candle, it means that close > open
    private var isGreenCandle: Bool {
        if candleNormalized.close > candleNormalized.open {
            return true
        } else {
            return false
        }
    }
    
    private var greater: Double {
        return max(candleNormalized.close, candleNormalized.open)
    }
    
    private var minor: Double {
        return min(candleNormalized.close, candleNormalized.open)
    }
    
    private func pointY(normalizedValue: Double) -> Double {
        return (1.0 - normalizedValue) * Double(self.rect.height)
    }
    
    
    var pathVerticalLine: Path {
        return Path { p in
            let top = (1 - candleNormalized.high) * Double(self.rect.height)
            let low = (1 - candleNormalized.low) * Double(self.rect.height)
            
            //Vertical line
            p.move(to: CGPoint(x: self.rect.midX, y: CGFloat(top)))
            p.addLine(to: CGPoint(x: self.rect.midX, y: CGFloat(low)))
            p.closeSubpath()
        }
    }
    
    var pathBody: Path {
        return Path { p in
            //rectangle
            //check which is grater -> open or close
            let topBody = (1 - greater) * Double(rect.height)
            let lowBody = (1 - minor) * Double(rect.height)
            p.addLines([
                CGPoint(x: rect.midX - 2, y: CGFloat(topBody)),
                CGPoint(x: rect.midX + 2, y: CGFloat(topBody)),
                CGPoint(x: rect.midX + 2, y: CGFloat(lowBody)),
                CGPoint(x: rect.midX - 2, y: CGFloat(lowBody)),
            ])
            p.closeSubpath()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            ZStack(alignment: Alignment.leading) {
                
                self.pathBody
                    .stroke(isGreenCandle ?  Color.green : Color.red,
                            style: StrokeStyle(lineWidth: 3))
                    
                self.pathVerticalLine
                    .stroke(isGreenCandle ?  Color.green : Color.red,
                            style: StrokeStyle(lineWidth: 1))
                
            }
        }
    }
}

struct CandleView_Previews: PreviewProvider {
    static var previews: some View {
        CandleView(candleNormalized: candleNormalized, rect:  CGRect(x: 0, y: 0, width: 10, height: UIScreen.main.bounds.height / 3))
    }
}

var candle = HistoricalData(time: 1614297600, high: 5161584.19, low: 4699601.04, open: 5014609.19, volumefrom: 25805.69, volumeto: 127577397503.73, close: 4940025.37, conversionType: "direct", conversionSymbol: "")

var candleNormalized = HistoricalData(time: 1616889600, high: 0.731052958642319, low: 0.6998354353253541, open: 0.71871794820908, volumefrom: 899.28, volumeto: 5502743303.46, close: 0.7286961767957689, conversionType: "direct", conversionSymbol: "")
