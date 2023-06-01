//
//  StoreBlock.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/18/23.
//

import SwiftUI

struct StoreBlock: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var dogobj: FetchedResults<Dog>
    @FetchRequest(sortDescriptors: [], animation: .default) var completedtimers: FetchedResults<CompletedTimers>
    
    let hexColors = readColors()
    
    var food : Food
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                .cornerRadius(5)
                .frame(width: 100, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(hex: findHex(color: "French Beige", hexColors: hexColors))!, lineWidth: 4)
                )
                .shadow(color: Color(hex: findHex(color: "French Beige", hexColors: hexColors))!, radius: 4)
                
            VStack{
                Text(food.name)
                    .frame(width:90, height:20)
                    .font(.system(size: 12))
                    .padding(.leading)
                    .padding(.top,22.5)
                    .padding(.trailing)
                
                Image(food.image)
                    .resizable()
                    .padding(.top, -5)
                    .frame(width: 40, height: 28.5)
                
                HStack{
                    
                    VStack{
                        
                        HStack{
                            Image(systemName: "hockey.puck.fill")
                                .resizable()
                                .frame(width:15, height: 10)
                                .foregroundColor(.yellow)
                            Text("\(food.cost)")
                                .font(.system(size: 15))
                            Spacer()
                        }
                        .padding(.bottom, -10)
                        
                        HStack{
                            Image(systemName: "face.smiling.fill")
                                .resizable()
                                .frame(width: 15, height: 15,alignment: .top)
                                .foregroundColor(.yellow)
                            Text("\(food.hapiness)")
                                .font(.system(size: 14))
                            Spacer()
                        }
                        .padding(.bottom, 30)
                        
                    }
                    .frame(maxHeight:22)
                    .padding(.leading, 8.5)
                    
                    Button{
                        dogobj.last!.lasthappy = Date()
                        dogobj.last!.hapiness = dogobj.last!.hapiness + Float(food.hapiness)
                        if(dogobj.last!.hapiness > 100)
                        {
                            dogobj.last!.hapiness = 99
                        }
                        dogobj.last!.lastfed = Date()
                        dogobj.last!.coins = dogobj.last!.coins - Int16(food.cost)
                        try? viewContext.save()
                    } label: {
                        ZStack{
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(hex: findHex(color: "Main Blue", hexColors: hexColors)))
                                .shadow(radius: 3)
                            Image(systemName: "cart.badge.plus.fill")
                                .resizable()
                                .frame(width: 20, height: 15)
                                .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                        }
                    }
                    .padding(.trailing, 8.5)
                    .padding(.bottom, 30)
                }
            }
            .frame(width: 100, height: 100)
            
        }
    }
}
