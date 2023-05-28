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
                .fill(Color.init(red: 255/255, green: 235/255, blue: 204/255))
                .edgesIgnoringSafeArea(.all)
            
            Image("livingRoom")
                .resizable()
                .scaledToFill()
                .offset(x: -1, y: -4)
                .blur(radius: 10)
            
            VStack{
                HStack{
                    Image(systemName: "hockey.puck.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.yellow)
                        .padding(.leading)
                    Text("\(dogobj.last!.coins)")
                        .font(.system(size:32))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    NavigationLink{
                        CoinHistoryView()
                    } label: {
                        ZStack{
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                            Image(systemName: "clock.fill")
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.trailing)
                }
                .padding(.top, 50)
                ScrollView{
                    FoodStoreView()
                }
            }
        }
        .navigationTitle("Store")
    }
}
