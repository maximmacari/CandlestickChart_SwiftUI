//
//  HDatum.swift
//  CandlestickChart
//
//  Created by Maxim Macari on 28/3/21.
//

import SwiftUI

// MARK: - Datum
struct HistoricalData: Codable, Hashable {

    var time: Int
    var high, low, open, volumefrom: Double
    var volumeto, close: Double
    var conversionType: String
    var conversionSymbol: String

    enum CodingKeys: String, CodingKey {
        case time, high, low, open
        case volumefrom, volumeto, close, conversionType, conversionSymbol
    }
}
