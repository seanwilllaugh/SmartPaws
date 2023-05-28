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
                .fill(Color.init(red: 255/255, green: 235/255, blue: 204/255))
                .edgesIgnoringSafeArea(.all)
            
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            VStack{
                Text("Tasks")
                    .font(.largeTitle)
                    .padding(.top)
                
                ZStack{
                    Rectangle()
                        .border(.black)
                        .cornerRadius(10)
                        .frame(width: 300, height: 160)
                        .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                    VStack{
                        Text("Create a New Task")
                            .font(.title2)
                            .frame(alignment: .center)
                        TextField("Task", text: $task)
                            .frame(width: 250, alignment: .center)
                            .cornerRadius(5)
                            .border(.black)
                            .padding(.top, -10)
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
                            .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                            .frame(width: 300, height: 20)
                            .border(.black)
                            .cornerRadius(5)
                        Text("Save Task")
                            .foregroundColor(.black)
                    }
                    .frame(alignment: .center)
                }
                
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                
                Text("Current Tasks")
                    .font(.title2)
        
                ScrollView{
                    ForEach(tasks) { task in
                        if(task.isCompleted == false){
                            TaskRow(task: task)
                        }
                    }
                }
                
                
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
        }
        .onAppear(perform: {
            for tag in tags{
                tagList.append(tag.name!)
            }
        })
    }
}
