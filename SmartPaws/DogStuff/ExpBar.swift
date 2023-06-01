//
//  ExpBar.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/22/23.
//

import SwiftUI

struct ExpBar: View {
    var expPoints : Int
    var level     : Int
    let hexColors = readColors()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 100, height: 15)
                    .foregroundColor(.gray)

                    Rectangle()
                        .frame(width: CGFloat(expPoints), height: 15)
                        .foregroundColor(.yellow)
            }
        }
        .frame(width:100, height: 15)
        .border(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors))!, width: 2)
    }
    
    private func calculateExpWidth(geometry: GeometryProxy, expPoints : Int, level : Int) -> CGFloat {
        var expProgress = 0
        
        expProgress = expPoints
        
        return CGFloat(expProgress)
    }
}
