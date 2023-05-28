//
//  Level20View.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/21/23.
//

import SwiftUI

struct Level20View: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var dogobj: FetchedResults<Dog>
    @FetchRequest(sortDescriptors: [], animation: .default) var completedtimers: FetchedResults<CompletedTimers>

    let foodList = initializeFood()
    
    var body: some View {
        Image("level20")
            .padding(.top)
        
        Rectangle()
            .frame(width: 200,height:3)
            .foregroundColor(.white)
            .padding(.top, -10)

        HStack{
            ForEach(foodList) { food in
                if(food.level == 20) {
                    StoreBlock(food: food)
                }
            }
        }
    }
}
