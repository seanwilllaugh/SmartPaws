//
//  CompletedTimerView.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/26/23.
//

import SwiftUI

struct CompletedTimerView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: [], animation: .default) var completedtimers: FetchedResults<CompletedTimers>
    @FetchRequest(sortDescriptors: [], animation: .default) var tasks: FetchedResults<Task>
    @FetchRequest(sortDescriptors: [], animation: .default) var tags: FetchedResults<Tag>
    
    let hexColors = readColors()
    
    var body: some View {
        ZStack { // 4
            Rectangle()
                .frame(width: 300, height: 400)
                .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: findHex(color: "French Beige", hexColors: hexColors))!, lineWidth: 4)
                )
            
            VStack{
                Text("Study Session Completed!")
                    .underline()
                    .font(.system(size: 24))
                    .padding(.bottom, 10)
                
                Text("Time Spent : \(Int(completedtimers.last!.length/60)) Minutes")
                    .padding(.bottom, 5)
                Text("Tag : \(completedtimers.last!.tag ?? "None Selected")")
                    .padding(.bottom, 5)
                Text("EXP Earned : \(Int(completedtimers.last!.length/30)) XP")
                    .padding(.bottom, 5)
                HStack{
                    Text("Coins Earned :")
                    Image(systemName: "hockey.puck.fill")
                        .foregroundColor(.yellow)
                    Text("\(completedtimers.last!.coins)")
                }
                .padding(.bottom, 10)
                
                Text("Finish Any Tasks?")
                    .underline()
                ScrollView{
                    ForEach(tasks){ task in
                        if(task.isCompleted == false){
                            TaskRow(task: task)
                        }
                    }
                }
            }
            .frame(height: 345, alignment: .top)
            .offset(y: -20)
        }
        .offset(y:-50)
        .frame(width: 300, height: 400)
    }
}

struct CompletedTimerView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedTimerView()
    }
}
