//
//  FoodStoreView.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/18/23.
//

import SwiftUI

struct FoodStoreView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var dogobj: FetchedResults<Dog>
    @FetchRequest(sortDescriptors: [], animation: .default) var completedtimers: FetchedResults<CompletedTimers>

    let foodList = initializeFood()
    
    var body: some View {
        VStack{
            Level1View()
            Level5View()
            Level10View()
            Level20View()
        }
    }
}

struct FoodStoreView_Previews: PreviewProvider {
    static var previews: some View {
        FoodStoreView()
    }
}
