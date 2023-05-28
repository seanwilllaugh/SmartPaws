//
//  TagDetails.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/23/23.
//

import SwiftUI
import CoreData
import Foundation

struct TagDetails: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    @FetchRequest(sortDescriptors: [], animation: .default) var tasks: FetchedResults<Task>
    
    let hexColors = readColors()
    let tag : Tag
    
    func deleteTag() {
        viewContext.delete(tag)
        //try? viewContext.save()
        dismiss()
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.init(red: 255/255, green: 235/255, blue: 204/255))
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Name  : \(tag.name!)")
                Text("Color : \(tag.color!)")
                
                Button{
                    deleteTag()
                } label: {
                    Rectangle()
                        .border(.black)
                        .cornerRadius(10)
                        .frame(width: 100, height: 25)
                        .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                }
                
                Text("Current Tasks")
                    .font(.title2)
                
                ScrollView{
                    ForEach(tasks) { task in
                        if(task.tasktag == tag.name) {
                            if(task.isCompleted == false){
                                TaskRow(task: task)
                            }
                        }
                    }
                }
                .frame(width: 300, height: 300)
            }
        }
    }
}
