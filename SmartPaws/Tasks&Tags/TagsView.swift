//
//  TagsView.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/23/23.
//

import SwiftUI

struct TagsView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var tags: FetchedResults<Tag>
    
    @State private var name  = ""
    @State private var color = ""
    
    @State private var showingTagDetails = false
    
    let hexColors = readColors()
    let colorList = ["Deep Aquamarine", "Deep Peach", "Deep Coffee", "Deep Pink", "Deep Red", "Deep Violet", "Deep Sky Blue", "Deep Lilac", "Deep Lemon", "Deep Green"]
    
    func saveTag() {
        let newTag = Tag(context: viewContext)
        
        newTag.id = UUID()
        newTag.createddate = Date()
        newTag.name = name
        newTag.color = color
        newTag.coinsNum = 0
        newTag.expNum  = 0
        newTag.taskComp = 0
        newTag.taskNum = 0
        newTag.timerNum = 0
        newTag.timerTime = 0
        
        try? viewContext.save()
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Rectangle()
                    .fill(Color(hex: findHex(color: "Light French Beige", hexColors: hexColors))!)
                    .edgesIgnoringSafeArea(.all)
                
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                VStack{
                    Text("Tags")
                        .font(.largeTitle)
                        .padding(.top)
                    
                    Spacer()
                    
                    ZStack{
                        Rectangle()
                            .border(.black)
                            .cornerRadius(10)
                            .frame(width: 300, height: 120)
                            .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: findHex(color: "French Beige", hexColors: hexColors))!, lineWidth: 4)
                            )
                        VStack{
                            Text("Create a New Tag")
                                .font(.title2)
                                .frame(alignment: .center)
                            TextField("Name of Tag", text: $name)
                                .frame(width: 150, alignment: .center)
                                .cornerRadius(5)
                                .border(Color(hex: findHex(color: "French Beige", hexColors: hexColors))!)
                            Picker("Color of Tag", selection: $color){
                                ForEach(colorList, id: \.self) {
                                    //Image(systemName: "tag.fill")
                                      //  .foregroundColor(Color(hex: findHex(color: "\($0)", hexColors: hexColors)))
                                    Text("\($0)")
                                }
                            }
                        }
                    }
                    Button{
                        saveTag()
                    } label: {
                        ZStack{
                            Rectangle()
                                .foregroundColor(Color(hex: findHex(color: "Main Blue", hexColors: hexColors)))
                                .frame(width: 200, height: 50)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors))!, lineWidth: 2)
                                )
                            Text("Save Tag")
                                .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                                .font(.title)
                        }
                        .frame(alignment: .center)
                    }
                    
                    Spacer()
                    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    ZStack{
                        Rectangle()
                            .frame(width: 360)
                            .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                            .cornerRadius(10.0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: findHex(color: "French Beige", hexColors: hexColors))!, lineWidth: 4)
                            )
                        
                        VStack{
                            Text("Current Tags")
                                .font(.title2)
                                .padding(.top)
                            
                            ScrollView{
                                ForEach(tags) { tag in
                                    HStack{
                                        NavigationLink{
                                            TagDetails(tag: tag)
                                        } label: {
                                            HStack{
                                                Image(systemName: "tag.fill")
                                                    .foregroundColor(Color(hex: findHex(color: tag.color!, hexColors: hexColors)))
                                                    .padding(.leading)
                                                Text(tag.name!)
                                                    .foregroundColor(.black)
                                                Spacer()
                                            }
                                            .frame(width: 355, height: 50)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 400)
                    
                    Spacer()
                }
            }
            .onAppear(perform: {
                try? viewContext.save()
            })
        }
    }
}
