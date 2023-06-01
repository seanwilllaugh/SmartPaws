//
//  Dog.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/16/23.
//

import SwiftUI

struct DogObj: View {
    @State var dateTime = Date()
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var dogobj: FetchedResults<Dog>
    
    var body: some View {
        VStack{
            /*Text("Level \(getDogLevel(dog: dogobj.last!))")
                .offset(y:40)
                .foregroundColor(.black)
                .fontDesign(.rounded)
                .fontWeight(.bold)
                .font(.system(size: 28))*/
            
            Image(getDogState(dog: dogobj.last!))
                .resizable()
                .frame(width:150, height: 150)
                //.offset(y: 30)
        }
        .onAppear(perform: {
            if((dogobj.last?.lastfed!.advanced(by: 86400))! < Date())
            {
                dogobj.last!.state = "dead"
                try? viewContext.save()
            }
        })
    }
}

func getDogState(dog: Dog) -> String{
    var dogState = ""
    
    dogState = dog.breed! + dog.state!
    
    print(dogState)
    
    return dogState
}

func getDogLevel(dog: Dog) -> Int{
    if(dog.experience >= 100){
        dog.level = dog.level + 1
        dog.experience = dog.experience - 100
    }
    
    return Int(dog.level)
}
