//
//  GodPanelView.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/17/23.
//

import SwiftUI
import CoreData

struct GodToolbar: View{
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var dogobj: FetchedResults<Dog>
    
    let hexColors = readColors()
    
    var body: some View{
        HStack{
            // Kill Button
            Button{
                dogobj.last!.lastfed = Date().advanced(by: -32000)
                //dogobj.last!.state! = "dead"
                try? viewContext.save()
                print("Killed Dog")
            }label: {
                ZStack{
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                    Image(systemName: "flame")
                        .foregroundColor(.black)
                }
            }
            
            // Revive Button
            Button{
                dogobj.last!.lastfed = Date()
                dogobj.last!.state! = "idle"
                try? viewContext.save()
                print("Revived Dog")
            }label: {
                ZStack{
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                    Image(systemName: "suit.heart.fill")
                        .foregroundColor(.black)
                }
            }
            
            //GodPanel
            NavigationLink{
                GodPanelView()
            }label: {
                ZStack{
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                    Image(systemName: "sparkles")
                        .foregroundColor(.black)
                }
            }
            
            // New Dog Button
            Button{
                let newDog = Dog(context: viewContext)
                
                newDog.id = UUID()
                newDog.birthday = Date()
                newDog.coins = 0
                newDog.breed = "Huskey"
                newDog.cosmetics = "none"
                newDog.lastfed = Date()
                newDog.state = "idle"
                newDog.hapiness = 50.00
                newDog.level = 1
                newDog.experience = 0
                
                try? viewContext.save()
                
                print("New Dog Created")
            }label: {
                ZStack{
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                    Image(systemName: "pawprint.fill")
                        .foregroundColor(.black)
                }
            }
            
            // Feed Button
            Button{
                dogobj.last!.lastfed! = Date()
                try? viewContext.save()
                print("Fed Dog")
            }label: {
                ZStack{
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                    Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct GodPanelView: View {
    @FetchRequest(sortDescriptors: [], animation: .default) var dogobj: FetchedResults<Dog>
    @Environment(\.managedObjectContext) var viewContext

    @State private var lastfedNew = Date()
    @State private var coinsNew = ""
    @State private var breedNew = ""
    
    var body: some View {
        Form{
            Section(header: Text("Last Fed Date")){
                DatePicker("Select a date", selection: $lastfedNew, displayedComponents: .date)
            }
            Section(header: Text("Coins")){
                TextField("Amount of Coins", text: $coinsNew)
            }
            Section(header: Text("Breed")){
                TextField("Breed of Dog", text: $breedNew)
            }
            Section{
                Button("Save"){
                    dogobj.last!.lastfed = lastfedNew
                    dogobj.last!.coins   = Int16(coinsNew)!
                    dogobj.last!.breed   = breedNew
                    try? viewContext.save()
                }
            }
        }
        .onAppear(perform: {
            lastfedNew = dogobj.last!.lastfed!
            coinsNew = String(dogobj.last!.coins)
            breedNew = dogobj.last!.breed!
        })
    }
}

 
