//
//  StatsView.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/24/23.
//

import SwiftUI

struct tagData: Identifiable{
    let id    : UUID
    let name  : String
    let color : String
    var taskNum     = 0
    var taskComp    = 0
    var timerNum    = 0
    var timerAmt    = 0
    var expEarned   = 0
    var coinsEarned = 0
}

struct StatsView: View {
    @Environment(\.managedObjectContext) var viewContext
   
    @FetchRequest(sortDescriptors: [], animation: .default) var completedtimers: FetchedResults<CompletedTimers>
    @FetchRequest(sortDescriptors: [], animation: .default) var dogobj: FetchedResults<Dog>
    @FetchRequest(sortDescriptors: [], animation: .default) var tasks: FetchedResults<Task>
    @FetchRequest(sortDescriptors: [], animation: .default) var tags: FetchedResults<Tag>
    
    let hexColors = readColors()
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color(hex: findHex(color: "Light French Beige", hexColors: hexColors))!)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                
                HStack{
                    Text("*Tag*")
                        .padding(.leading)
                        .frame(width: 80)
                    
                    Text("*Time*")
                        .frame(width: 35)
                        
                    Text("*Timers*")
                        .frame(width: 45)
                        
                    Text("*Coins*")
                        .frame(width: 40)
                        
                    Text("*EXP*")
                        .frame(width: 30)
                        
                    Text("*Tasks*")
                        .frame(width: 35)
                        
                    Text("*Completed Tasks*")
                        .frame(width: 62)
                        .padding(.trailing)
                }
                .font(.caption)
            
                ForEach(tags) { tag in
                    
                    HStack{
                        Image(systemName: "tag.fill")
                            .foregroundColor(Color(hex: findHex(color: tag.color!, hexColors: hexColors)))
                            .padding(.leading)
                        
                        Text("\(tag.name ?? "n/a"):")
                            .frame(width: 70)
    
                        Text("\(tag.timerTime/60)")
                            .frame(width: 35)
                            
                        Text("\(tag.timerNum)")
                            .frame(width: 45)
                            
                        Text("\(tag.coinsNum)")
                            .frame(width: 40)
                            
                        Text("\(tag.expNum)")
                            .frame(width: 30)
                            
                        Text("\(tag.taskNum)")
                            .frame(width: 35)
                            
                        Text("\(tag.taskComp)")
                            .frame(width: 62)
                            .padding(.trailing)
                        
                    }
                    .padding(.bottom)
                    .font(.caption2)
                    
                }
                
                Spacer()
            }
            .padding(.top)
            
        }
    }
}
