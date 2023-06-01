//
//  FoodBar.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/17/23.
//

import SwiftUI

struct FoodBar: View {
    let hexColors = readColors()
    
    let targetDate: Date
        
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 100, height: 15)
                    .foregroundColor(.gray)
                    .border(.black, width: 2)
                
                Rectangle()
                    .frame(width: calculateProgressWidth(geometry: geometry), height: 15)
                    .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
            }
        }
        .frame(width:100, height: 15)
        .border(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors))!, width: 2)
    }
    
    private func calculateProgressWidth(geometry: GeometryProxy) -> CGFloat {
        let progress = (CGFloat(targetDate.timeIntervalSinceReferenceDate-Date().timeIntervalSinceReferenceDate))/86400
        let maxWidth = 100.0
        
        
        return progress * maxWidth
    }
}
