//
//  CandlestickChartView.swift
//  CandlestickChart
//
//  Created by Maxim Macari on 28/3/21.
//

import SwiftUI

struct CandlestickChartView: View {
    
    @State var indicatorLocation:CGPoint = .zero
    @State var myFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / CGFloat(data.count), height: UIScreen.main.bounds.height / 3)
    @State var showIndicator: Bool
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        VStack {
            if showIndicator {
                let indexTouched = Int(indicatorLocation.x / CGFloat(candleWidthScreenPercentaje))
                
                HStack(spacing: 0){
                    Text("\(tsToDate(timestamp: data[indexTouched].time))")
                    
                    Spacer()
                }
                HStack{
                    Text("\(getLocationPrice(yPointTouched: indicatorLocation.y), specifier: "%.2f") €")
                    
                    Spacer()
                }
            } else {
                HStack(spacing: 0){
                    Text("\(dateFormatter.string(from: Date()))")
                    
                    Spacer()
                }
                HStack{
                    Text("\(data.last?.close ?? Double.zero, specifier: "%.2f") €")
                    
                    Spacer()
                }
            }
            GeometryReader { geo in
                ZStack {
                    HStack(spacing: 0){
                        ForEach(normalizeData, id: \.self) { data in
                            CandleView(candleNormalized: data, rect: myFrame)
                        }
                    }
                    
                    if showIndicator {
                        IndicatorPointView()
                            .position(indicatorLocation)
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged{ touch in
                            if geo.frame(in: .local).contains(touch.location){
                                showIndicator = true
                                self.indicatorLocation = touch.location
                            } else {
                                showIndicator = false
                            }
                        }
                        .onEnded({ (touch) in
                            showIndicator = false
                        })
                )
            }
            .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height / 3)
        }
        .onAppear(){
            //this doesnt go here
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
        }
    }
    
    //percentaje of each candle
    var candleWidthScreenPercentaje: Double {
        return Double(UIScreen.main.bounds.width) / Double(data.count)
    }
    
    private var min: Double{
        let minLow = data.map { $0.low }.min()
        let minHigh = data.map { $0.high }.min()
        let minClose = data.map { $0.close }.min()
        let minOpen = data.map { $0.open }.min()
        
        guard minLow != nil, minHigh != nil, minClose != nil, minOpen != nil else {
            print("Min not found")
            return Double.zero
        }
        let min = [minLow, minHigh, minOpen, minClose] as! [Double]
        
        return min.min() ?? Double.zero
    }
    
    private func tsToDate(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        return dateFormatter.string(from: date)
    }
    
    //    private func reverseNormalization(value: Double) -> Double {
    //        return (value * (max - min)) + min
    //    }
    
    private func getLocationPrice(yPointTouched: CGFloat) -> Double {
        // max - myFrame.height.size
        // min - myFrame.minY - location.y
        
        let position = myFrame.maxY - yPointTouched
        
        return (Double(position) * max) / Double(myFrame.maxY)
        
    }
    
    private var max: Double {
        
        let maxLow = data.map { $0.low }.max()
        let maxHigh = data.map { $0.high }.max()
        let maxClose = data.map { $0.close }.max()
        let maxOpen = data.map { $0.open }.max()
        
        guard maxLow != nil, maxHigh != nil, maxClose != nil, maxOpen != nil else {
            print("Min not found")
            return Double.zero
        }
        
        
        let max = [maxLow, maxHigh, maxOpen, maxClose] as! [Double]
        
        return max.max() ?? Double.infinity
    }
    
    private func normalizeValue(value: Double) -> Double {
        return (value - min) / (max - min)
    }
    
    var normalizeData: [HistoricalData] {
        //Double low, high, close, open
        // find max and min from those attributes
        return data.map {
            HistoricalData(time: $0.time,
                           high: normalizeValue(value: $0.high),
                           low: normalizeValue(value: $0.low),
                           open: normalizeValue(value: $0.open),
                           volumefrom: $0.volumefrom, volumeto: $0.volumeto,
                           close: normalizeValue(value: $0.close),
                           conversionType: $0.conversionType, conversionSymbol: $0.conversionSymbol)
        }
    }
    
    struct IndicatorPointView: View {
        var body: some View {
            
            ZStack{
                
//                Rectangle()
//                    .frame(width: 1, height: UIScreen.main.bounds.height / 3)

                Rectangle()
                    .frame(width: 1, height: UIScreen.main.bounds.width * 2)
                    .rotationEffect(.init(degrees: Double(90)))
                
                ZStack{
                    Circle()
                        .fill(Color.red)
                    Circle()
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 4))
                }
//                .shadow(color: Color.blue, radius: 6, x: 4, y: 4)
//                .shadow(color: Color.blue, radius: 6, x: -4, y: -4)
            }
            .frame(width: 10, height: 10)
            
        }
    }
}

struct CandlestickChartView_Previews: PreviewProvider {
    static var previews: some View {
        CandlestickChartView(indicatorLocation: CGPoint(x: 0, y: 0), myFrame: CGRect(x: 0, y: 0, width: 10, height: UIScreen.main.bounds.height / 3), showIndicator: false)
    }
}

var data: [HistoricalData] = [
    HistoricalData(time: 1614297600, high: 5161584.19, low: 4699601.04, open: 5014609.19, volumefrom: 25805.69, volumeto: 127577397503.73, close: 4940025.37, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1614384000, high: 5148975.87, low: 4819161.43, open: 4940025.37, volumefrom: 14452.5, volumeto: 72467318103.11, close: 4931611.78, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1614470400, high: 4973269.83, low: 4594146.1, open: 4931611.78, volumefrom: 23067.3, volumeto: 109899386769.72, close: 4819233.58, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1614556800, high: 5326548.81, low: 4800817.01, open: 4819233.58, volumefrom: 22556.13, volumeto: 114348849997.42, close: 5310818.84, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1614643200, high: 5369972.75, low: 5033444.86, open: 5310818.84, volumefrom: 15541.1, volumeto: 80885737494.28, close: 5177370.53, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1614729600, high: 5626507.63, low: 5148055.05, open: 5177370.53, volumefrom: 19310.45, volumeto: 104787290279.17, close: 5405253.35, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1614816000, high: 5540223.78, low: 5134667.9, open: 5405253.35, volumefrom: 20372.75, volumeto: 108244496556.23, close: 5224906.82, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1614902400, high: 5345199.15, low: 5005169.22, open: 5224906.82, volumefrom: 19374.15, volumeto: 100039521003.28, close: 5288974.2, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1614988800, high: 5323014.76, low: 5106735.64, open: 5288974.2, volumefrom: 9999.06, volumeto: 52314905628.36, close: 5288264.97, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1615075200, high: 5560256.32, low: 5288264.97, open: 5288264.97, volumefrom: 14291.86, volumeto: 77658625785.0, close: 5519578.04, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1615161600, high: 5679956.15, low: 5351498.76, open: 5519578.04, volumefrom: 15775.58, volumeto: 86884313813.56, close: 5679819.76, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1615248000, high: 5953444.22, low: 5646048.44, open: 5679819.76, volumefrom: 17897.94, volumeto: 104772066923.13, close: 5944749.24, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1615334400, high: 6182409.11, low: 5781318.92, open: 5944749.24, volumefrom: 22366.33, volumeto: 134126379576.92, close: 6052622.36, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1615420800, high: 6300109.3, low: 5902220.43, open: 6052622.36, volumefrom: 20327.37, volumeto: 123884720384.26, close: 6272698.69, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1615507200, high: 6298112.26, low: 6017582.98, open: 6272698.69, volumefrom: 17220.94, volumeto: 106351179862.25, close: 6234572.7, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1615593600, high: 6700124.65, low: 6123119.22, open: 6234572.7, volumefrom: 18480.51, volumeto: 118744685699.0, close: 6677376.03, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1615680000, high: 6725569.51, low: 6437387.32, open: 6677376.03, volumefrom: 12535.18, volumeto: 82572214834.97, close: 6441546.05, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1615766400, high: 6613435.07, low: 6031341.65, open: 6441546.05, volumefrom: 22854.04, volumeto: 143469859479.58, close: 6087252.16, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1615852800, high: 6202671.17, low: 5840128.37, open: 6087252.16, volumefrom: 18854.41, volumeto: 113507119767.69, close: 6201934.08, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1615939200, high: 6422272.47, low: 5936523.74, open: 6201934.08, volumefrom: 15722.42, volumeto: 96550124930.89, close: 6415370.02, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1616025600, high: 6544576.9, low: 6215445.87, open: 6415370.02, volumefrom: 14237.83, volumeto: 90911711082.74, close: 6284147.47, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1616112000, high: 6467551.56, low: 6133763.91, open: 6284147.47, volumefrom: 12401.38, volumeto: 78627882419.93, close: 6327771.75, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1616198400, high: 6515482.49, low: 6304617.05, open: 6327771.75, volumefrom: 9627.49, volumeto: 61734049414.69, close: 6328871.6, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1616284800, high: 6379481.26, low: 6078642.79, open: 6328871.6, volumefrom: 11439.33, volumeto: 71274891848.68, close: 6255509.17, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1616371200, high: 6345892.81, low: 5887124.43, open: 6255509.17, volumefrom: 14754.71, volumeto: 90639314752.99, close: 5901349.23, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1616457600, high: 6072214.85, low: 5787330.99, open: 5901349.23, volumefrom: 13977.65, volumeto: 83040105490.59, close: 5911718.31, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1616544000, high: 6223645.76, low: 5661390.74, open: 5911718.31, volumefrom: 18563.79, volumeto: 110525599675.5, close: 5710100.21, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1616630400, high: 5808251.22, low: 5509327.37, open: 5710100.21, volumefrom: 19145.1, volumeto: 108540856452.52, close: 5613784.17, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1616716800, high: 6045143.4, low: 5604743.82, open: 5613784.17, volumefrom: 11496.9, volumeto: 66961141919.02, close: 6043033.07, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1616803200, high: 6192434.18, low: 5920931.37, open: 6043033.07, volumefrom: 9627.73, volumeto: 58303763241.79, close: 6126038.36, conversionType: "direct", conversionSymbol: ""), HistoricalData(time: 1616889600, high: 6152329.49, low: 6085791.73, open: 6126038.36, volumefrom: 899.28, volumeto: 5502743303.46, close: 6147306.19, conversionType: "direct", conversionSymbol: "")
]


