//
//  HapinessBar.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/18/23.
//

import SwiftUI

struct HapinessBar: View {
    var hapiness : Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 100, height: 15)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(width: calculateHapinessWidth(geometry: geometry, hapiness: hapiness), height: 15)
                    .foregroundColor(.green)
            }
        }
        .frame(width:100, height: 15)
        .border(.black, width: 2)
    }
    
    private func calculateHapinessWidth(geometry: GeometryProxy, hapiness: Float) -> CGFloat
    {
        return CGFloat(hapiness)
    }
}
