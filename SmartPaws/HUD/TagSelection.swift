//
//  TagSelection.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/29/23.
//

import SwiftUI

struct TagSelection: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var tags: FetchedResults<Tag>
    
    @Binding var tagSelection : String
    @State private var tagList = ["Select a Tag"]
    
    let hexColors = readColors()
    
    var body: some View {
        ZStack { // 4
            Rectangle()
                .frame(width: 200, height: 30)
                .cornerRadius(5)
                .foregroundColor(Color(hex: findHex(color: "Main Blue", hexColors: hexColors)))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors))!, lineWidth: 2)
                )
            
            Picker("Select a Tag", selection: $tagSelection){
                ForEach(tagList, id: \.self){ tag in
                    Text(tag)
                        .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                }
            }
        }
        .onAppear(perform: {
            for tag in tags{
                tagList.append(tag.name!)
            }
        })
    }
}
