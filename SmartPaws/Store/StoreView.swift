//
//  TimerHistoryView.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/16/23.
//

import SwiftUI
import CoreData

struct StoreView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var dogobj: FetchedResults<Dog>
    @FetchRequest(sortDescriptors: [], animation: .default) var completedtimers: FetchedResults<CompletedTimers>
    let foodList = initializeFood()
    
    let hexColors = readColors()
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color(hex: findHex(color: "Light French Beige", hexColors: hexColors))!)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    ZStack{
                        
                        Rectangle()
                            .frame(width: 120, height: 40)
                            .cornerRadius(5)
                            .foregroundColor(Color(hex: findHex(color: "Main Blue", hexColors: hexColors)))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors))!, lineWidth: 2)
                            )
                            .shadow(color: Color(hex: findHex(color: "Main Blue", hexColors: hexColors))!, radius: 3)
                            .padding(.leading)
                        
                        HStack{
                            Image(systemName: "hockey.puck.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                                .padding(.leading)
                            Text("\(dogobj.last!.coins)")
                                .font(.system(size:32))
                                .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink{
                        CoinHistoryView()
                    } label: {
                        ZStack{
                            Circle()
                                .frame(width: 55, height: 55)
                                .foregroundColor(Color(hex: findHex(color: "Main Blue", hexColors: hexColors)))
                                .shadow(color: Color(hex: findHex(color: "Main Blue", hexColors: hexColors))!, radius: 3)
                            Circle()
                                .stroke(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors))!, style: StrokeStyle(lineWidth: 2))
                                .frame(width: 55, height: 55)
                            Image(systemName: "clock.fill")
                                .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                        }
                    }
                    .padding(.trailing)
                }
                //.padding(.top)
                ScrollView{
                    FoodStoreView()
                }
            }
        }
        .navigationTitle("Store")
    }
}
