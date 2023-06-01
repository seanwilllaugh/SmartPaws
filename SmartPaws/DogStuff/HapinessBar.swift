//
//  HapinessBar.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/18/23.
//

import SwiftUI

struct HapinessBar: View {
    @State var hapiness : Float
    @State var realhappiness = 0.0
    let targetDate : Date
    let hexColors = readColors()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 100, height: 15)
                    .foregroundColor(.gray)
                
                if(realhappiness > 66.6)
                {
                    Rectangle()
                        .frame(width: calculateHapinessWidth(hapiness: hapiness), height: 15)
                        .foregroundColor(.green)
                }else if(realhappiness < 66.6 && realhappiness > 33.3){
                    Rectangle()
                        .frame(width: calculateHapinessWidth(hapiness: hapiness), height: 15)
                        .foregroundColor(.yellow)
                }else{
                    Rectangle()
                        .frame(width: calculateHapinessWidth(hapiness: hapiness), height: 15)
                        .foregroundColor(.red)
                }
                    
            }
        }
        .frame(width:100, height: 15)
        .border(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors))!, width: 2)
        .onAppear(perform: {
            realhappiness = calculateHapinessWidth(hapiness: hapiness)
        })
    }
    
    private func calculateHapinessWidth(hapiness: Float) -> CGFloat
    {
        let progress = (CGFloat(targetDate.timeIntervalSinceReferenceDate-Date().timeIntervalSinceReferenceDate))/172800
        let maxWidth = 100.0
        
        return progress * maxWidth
    }
}
