//
//  TasksView.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/23/23.
//

import SwiftUI

struct TasksView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var tasks: FetchedResults<Task>
    @FetchRequest(sortDescriptors: [], animation: .default) var tags: FetchedResults<Tag>
    
    @State private var task = ""
    @State private var taskTag = ""
    @State private var chosenDue = Date()
    @State private var priority = ""
    @State private var tagList = ["Select a Tag"]
    
    let taskPriority = ["Priority", "Low", "Medium", "High", "Urgent"]
    let hexColors = readColors()
    
    func saveTask() {
        let newTask = Task(context: viewContext)
        
        newTask.id = UUID()
        newTask.datecreated = Date()
        newTask.duedate = chosenDue
        newTask.priority = priority
        newTask.tasktag = taskTag
        newTask.taskstring = task
        newTask.isCompleted = false
        
        for tag in tags{
            if(newTask.tasktag == tag.name!){
                tag.taskNum = tag.taskNum + 1
            }
        }
        
        try? viewContext.save()
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color(hex: findHex(color: "Light French Beige", hexColors: hexColors))!)
                .edgesIgnoringSafeArea(.all)
            
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            VStack{
                Text("Tasks")
                    .font(.largeTitle)
                    .padding(.top)
                    .padding(.bottom)
                
                Spacer()
                
                ZStack{
                    Rectangle()
                        .cornerRadius(10)
                        .frame(width: 300, height: 160)
                        .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: findHex(color: "French Beige", hexColors: hexColors))!, lineWidth: 4)
                        )
                    
                    VStack{
                        Text("Create a New Task")
                            .font(.title3)
                            .frame(alignment: .center)
                            .padding(.top, 5)
                        TextField("Task", text: $task)
                            .frame(width: 250, alignment: .center)
                            .foregroundColor(Color(hex: findHex(color: "Black", hexColors: hexColors)))
                            .cornerRadius(5)
                            .border(Color(hex: findHex(color: "French Beige", hexColors: hexColors))!)
                        Picker("Tag", selection: $taskTag){
                            ForEach(tagList, id: \.self){ tag in
                                Text(tag)
                            }
                        }
                        .padding(.top, -10)
                        DatePicker("Select a Due Date", selection: $chosenDue, displayedComponents: .date)
                            .frame(width: 250)
                            .padding(.top, -10)
                        Picker("Priority", selection: $priority){
                            ForEach(taskPriority, id: \.self){
                                Text("\($0)")
                            }
                        }
                        .padding(.top, -10)
                    }
                }
                .padding(.top, -20)
                
                Button{
                    saveTask()
                } label: {
                    ZStack{
                        Rectangle()
                            .foregroundColor(Color(hex: findHex(color: "Main Blue", hexColors: hexColors)))
                            .frame(width: 200, height: 50)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors))!, lineWidth: 2)
                            )
                        Text("Save Task")
                            .font(.title)
                            .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                    }
                    .frame(alignment: .center)
                }
                
                Spacer()
                
                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                
                ZStack{
                    Rectangle()
                        .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                        .cornerRadius(10.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: findHex(color: "French Beige", hexColors: hexColors))!, lineWidth: 4)
                        )
                        .frame(width: 360, height: 220)
                    VStack{
                        Text("Current Tasks")
                            .font(.title2)
                        
                        ScrollView{
                            ForEach(tasks) { task in
                                if(task.isCompleted == false){
                                    TaskRow(task: task)
                                }
                            }
                        }
                    }
                    .frame(width: 355, height: 200)
                }
                
                Spacer()
                
                ZStack{
                    Rectangle()
                        .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                        .cornerRadius(10.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: findHex(color: "French Beige", hexColors: hexColors))!, lineWidth: 4)
                        )
                        .frame(width: 360, height: 220)
                    
                    VStack{
                        Text("Completed Tasks")
                            .font(.title2)
                        
                        ScrollView{
                            ForEach(tasks) { task in
                                if(task.isCompleted){
                                    TaskRow(task: task)
                                }
                            }
                        }
                    }
                    .frame(width: 355, height: 200)
                }
                
                Spacer()
            }
        }
        .onAppear(perform: {
            for tag in tags{
                tagList.append(tag.name!)
            }
        })
    }
}
