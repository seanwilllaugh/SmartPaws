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
        dismiss()
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color(hex: findHex(color: "Light French Beige", hexColors: hexColors))!)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                ZStack{
                    Rectangle()
                        .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                        .cornerRadius(10)
                        .frame(width: 300, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: findHex(color: "French Beige", hexColors: hexColors))!, lineWidth: 4)
                        )
                    
                    HStack{
                        Image(systemName: "tag.fill")
                            .resizable()
                            .foregroundColor(Color(hex: findHex(color: tag.color!, hexColors: hexColors)))
                            .frame(width: 25, height: 25)
                        Text(tag.name!)
                            .font(.title)
                    }
                    .frame(width: 280, height: 100)
                }
                    
                    
                Button{
                    deleteTag()
                } label: {
                    ZStack{
                        Rectangle()
                            .foregroundColor(Color(hex: findHex(color: "Main Blue", hexColors: hexColors)))
                            .frame(width: 200, height: 50)
                            .border(.black)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors))!, lineWidth: 4)
                            )
                        Text("Delete Tag")
                            .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                            .font(.title)
                    }
                }
                    
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
                        Text("Current Tasks")
                            .font(.title2)
                            .padding(.top)
                        
                        ScrollView{
                            ForEach(tasks) { task in
                                if(task.tasktag == tag.name) {
                                    if(task.isCompleted == false){
                                        TaskRow(task: task)
                                    }
                                }
                            }
                            .frame(width: 355)
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
}

