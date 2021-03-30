//
//  ContentView.swift
//  CandlestickChart
//
//  Created by Maxim Macari on 28/3/21.
//

import SwiftUI

struct ContentView: View {
    
    
    
    var body: some View {
        VStack(spacing: 0){
            
            Spacer()
            
            CandlestickChartView(showIndicator: false)
            
            Spacer()
        }
       
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

