//
//  TaskRow.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/26/23.
//

import SwiftUI

struct TaskRow: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var tags: FetchedResults<Tag>
    
    var task : Task
    
    let hexColors = readColors()
    
    var body: some View {
        HStack(){
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(lineWidth: 2)
                .frame(width: 25, height: 25)
                .cornerRadius(5.0)
                .foregroundColor(.black)
                .overlay {
                    Image(systemName: task.isCompleted ? "checkmark" : "")
                        .foregroundColor(.black)
                }
                .onTapGesture{
                    withAnimation(.spring()) {
                        task.isCompleted.toggle()
                        for tag in tags{
                            if(task.tasktag! == tag.name!) {
                                tag.taskComp = tag.taskComp + 1
                            }
                        }
                        
                        try? viewContext.save()
                    }
                }
                .padding(.leading)
            
            if(task.priority! == "Low"){
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color(hex: findHex(color: "Deep Moss Green", hexColors: hexColors)))
            }else if(task.priority! == "Medium"){
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color(hex: findHex(color: "Deep Lemon", hexColors: hexColors)))
            }else if(task.priority! == "High"){
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color(hex: findHex(color: "Deep Saffron", hexColors: hexColors)))
            }else if(task.priority! == "Urgent"){
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color(hex: findHex(color: "Deep Maroon", hexColors: hexColors)))
            }
            
            VStack(alignment: .leading){
                Text("\(task.tasktag!)")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: findHex(color: "Gray", hexColors: hexColors)))
                
                Text("\(task.taskstring!)")
                    .font(.system(size: 16))
                    .fontDesign(.rounded)
                    .padding(.top, -11.5)
                    .foregroundColor(Color(hex: findHex(color: "Black", hexColors: hexColors)))
                
                Text(task.duedate!, style: .date)
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: findHex(color: "Gray", hexColors: hexColors)))
                    .padding(.top, -12.5)
            }
            
            Spacer()
            
            Button{
                for tag in tags{
                    if(task.tasktag == tag.name!){
                        tag.taskNum = tag.taskNum - 1
                        if(task.isCompleted){
                            tag.taskComp = tag.taskComp - 1
                        }
                    }
                }
                
                viewContext.delete(task)
                
                try? viewContext.save()
            } label:{
                Image(systemName: "trash")
                    .foregroundColor(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors)))
            }
            .padding(.trailing)
        }
    }
}
