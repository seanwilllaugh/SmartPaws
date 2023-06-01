//
//  TimerControlView.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/17/23.
//

import SwiftUI

struct TimerControlView: View {
    @Binding var timerValue: CGFloat
    @State var angleValue: CGFloat = 0.0
    @State var isTimerRunning : Bool
    
    var toggleTimer: () -> Void
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let hexColors = readColors()
    let config = Config(minimumValue: 0.0,
                        maximumValue: 7200.0,
                        startValue: 0.0,
                        totalValue: 7200.0,
                        knobRadius: 10.0,
                        radius: 100.0)
    
    var timerString: String {
        let minutes = Int(timerValue)
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return String(format: "%02d:%02d", hours, remainingMinutes)
    }
    var timerLength: CGFloat {
        var length = 0.0
        if isTimerRunning{
            length = length + 0
        }else{
            length = timerValue
        }
        return length
    }
    
    var body: some View {
        ZStack {
            // Main Circle
            Circle()
                .frame(width: config.radius * 2, height: config.radius * 2)
                .scaleEffect(1.5)
                .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors))!)
                .shadow(color: Color(hex: findHex(color: "French Beige", hexColors: hexColors))!, radius: 7.5)
            
            // Dashes on Timer
            Circle()
                .stroke(Color(hex: findHex(color: "French Beige", hexColors: hexColors))!,
                        style: StrokeStyle(lineWidth: 8))
                .frame(width: config.radius * 2, height: config.radius * 2)
                .scaleEffect(1.45)
            
            /* Finished Progress Line
            Circle()
                .trim(from: 0.0, to: timerLength/config.totalValue)
                .stroke(Color(hex: findHex(color: "White", hexColors: hexColors))!, lineWidth: 4)
                .frame(width: config.radius * 2, height: config.radius * 2)
                .rotationEffect(.degrees(-90))*/
            
            //Current Progress line
            Circle()
                .trim(from: 0.0, to: timerValue/config.totalValue)
                .stroke(Color(hex: findHex(color: "Main Blue", hexColors: hexColors))!, lineWidth: 8)
                .frame(width: config.radius * 2, height: config.radius * 2)
                .rotationEffect(.degrees(-90))
                .scaleEffect(1.45)
            
            // Knob
            Circle()
                .fill(isTimerRunning ? Color.red : Color(hex: findHex(color: "Main Blue", hexColors: hexColors))!)
                .frame(width: config.knobRadius * 2.5, height: config.knobRadius * 2.5)
                .padding(10)
                .offset(y: -config.radius)
                .rotationEffect(Angle.degrees(Double(angleValue)))
                .gesture(DragGesture(minimumDistance: 0.0)
                    .onChanged({ value in
                        change(location: value.location)
                    }))
                .scaleEffect(1.45)
            
            Text(timerString)
                .font(.system(size: 48))
                .fontWeight(.thin)
                .fontDesign(.rounded)
                .foregroundColor(Color(hex: findHex(color: "Main Blue", hexColors: hexColors))!)
                .opacity(1.0)
                .offset(y: -75)
            
            DogObj()
                .offset(y: 30)
            
        }
        .onReceive(timer) { _ in
            if isTimerRunning && timerValue > config.minimumValue {
                timerValue -= 1.0
            }
        }
        .onAppear {
            timerValue = config.startValue
        }
    }
    
    private func change(location: CGPoint) {
        let vector = CGVector(dx: location.x, dy: location.y)
            let angle = atan2(vector.dy - (config.knobRadius + 10), vector.dx - (config.knobRadius + 10)) + .pi/2.0
            let fixedAngle = angle < 0.0 ? angle + 2.0 * .pi : angle
            let value = fixedAngle / (2.0 * .pi) * config.totalValue

            let roundedValue = round(value / 300.0) * 300.0 // Snap to nearest 5-minute interval
            let roundedAngle = roundedValue / config.totalValue * (2.0 * .pi)

            if roundedValue >= config.minimumValue && roundedValue <= config.maximumValue {
                timerValue = roundedValue
                angleValue = roundedAngle * 180 / .pi
            }
    }
    
}

struct Config {
    let minimumValue: CGFloat
    let maximumValue: CGFloat
    let startValue:   CGFloat
    let totalValue: CGFloat
    let knobRadius: CGFloat
    let radius: CGFloat
}
