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
    let colorList = ["Red", "Blue", "Green", "Yellow", "Purple", "Brown"]
    
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
                    .fill(Color.init(red: 255/255, green: 235/255, blue: 204/255))
                    .edgesIgnoringSafeArea(.all)
                
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                VStack{
                    Text("Tags")
                        .font(.largeTitle)
                        .padding(.top)
                    
                    ZStack{
                        Rectangle()
                            .border(.black)
                            .cornerRadius(10)
                            .frame(width: 300, height: 120)
                            .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                        VStack{
                            Text("Create a New Tag")
                                .font(.title2)
                                .frame(alignment: .center)
                            TextField("Name of Tag", text: $name)
                                .frame(width: 150, alignment: .center)
                                .cornerRadius(5)
                                .border(.black)
                            Picker("Color of Tag", selection: $color){
                                ForEach(colorList, id: \.self) {
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
                                .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                                .frame(width: 300, height: 20)
                                .border(.black)
                                .cornerRadius(5)
                            Text("Save Tag")
                                .foregroundColor(.black)
                        }
                        .frame(alignment: .center)
                    }
                    
                    Text("Current Tags")
                        .font(.title2)
                    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                    ScrollView{
                        ForEach(tags) { tag in
                            HStack{
                                NavigationLink{
                                    TagDetails(tag: tag)
                                } label: {
                                    HStack{
                                        Image(systemName: "tag.fill")
                                            .foregroundColor(Color(hex: findHex(color: tag.color!, hexColors: hexColors)))
                                        Text(tag.name!)
                                            .foregroundColor(.black)
                                    }
                                    .frame(width: 200, height: 50)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
