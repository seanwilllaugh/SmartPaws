import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.scenePhase) var scenePhase
    @FetchRequest(sortDescriptors: [], animation: .default) var completedtimers: FetchedResults<CompletedTimers>
    @FetchRequest(sortDescriptors: [], animation: .default) var tasks: FetchedResults<Task>
    @FetchRequest(sortDescriptors: [], animation: .default) var dogobj: FetchedResults<Dog>
    @FetchRequest(sortDescriptors: [], animation: .default) var tags: FetchedResults<Tag>
    
    @State var coinsTotal          = 0
    
    @State var isTimerRunning      = false
    @State var isTimerPaused       = false
    
    @State private var currentTime = ""
    @State var timerLength         : CGFloat = 0.0
    @State private var timerValue  : CGFloat = 0.0
    @State private var cancellable : AnyCancellable? = nil
    
    @State private var showingTagView = false
    @State private var showingTaskView = false
    
    @State var showingtagPopup = false
    @State private var tagList = ["Select a Tag"]
    @State var tagSelection = ""
    
    @State var showingCompletedTimer = false
    
    let hexColors = readColors()
    
    let timeCurrent = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView{
            ZStack {
                // Background Color
                Rectangle()
                    .fill(Color(hex: findHex(color: "Light French Beige", hexColors: hexColors))!)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(){
                    // Settings
                    HStack{
                        NavigationLink{
                            SettingsView()
                        } label: {
                            ZStack{
                                Rectangle()
                                    .frame(width: 110, height: 40)
                                    .foregroundColor(Color(hex: findHex(color: "Main Blue", hexColors: hexColors)))
                                    .cornerRadius(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors))!, lineWidth: 2)
                                    )
                                HStack{
                                    Image(systemName: "gear")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                                    Text("Settings")
                                        .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                                        .fontDesign(.rounded)
                                        .fontWeight(.medium)
                                        .font(.system(size: 14))
                                }
                            }
                        }
                        .padding(.leading)
                        
                        
                        VStack(){
                            Text(currentTime)
                                .font(.system(size: 34))
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                                .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors))!)
                                .onReceive(timeCurrent){ _ in
                                    updateTime()
                                }
                            Text(Date(), style: .date)
                                .font(.system(size: 14))
                                .fontWeight(.heavy)
                                .fontDesign(.rounded)
                                .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors))!)
                        }
                        .frame(maxWidth: .infinity)
                        
                        
                        // Store
                        NavigationLink{
                            StoreView()
                        } label: {
                            ZStack{
                                Rectangle()
                                    .frame(width: 110, height: 40)
                                    .foregroundColor(Color(hex: findHex(color: "Main Blue", hexColors: hexColors)))
                                    .cornerRadius(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors))!, lineWidth: 2)
                                    )
                                HStack{
                                    Image(systemName: "hockey.puck.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                                    Text("\(dogobj.last!.coins)")
                                        .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                                        .fontDesign(.rounded)
                                        .fontWeight(.medium)
                                }
                            }
                        }
                        .padding(.trailing)
                        
                    }
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .padding(.top, -20)
                    
                    Button{
                        showingTaskView.toggle()
                    } label: {
                        ZStack{
                            Rectangle()
                                .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(hex: findHex(color: "French Beige", hexColors: hexColors))!, lineWidth: 4)
                                )
                            
                            VStack{
                                Text("Coming Up")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .fontDesign(.rounded)
                                    .foregroundColor(Color(hex: findHex(color: "Black", hexColors: hexColors)))
                                    .padding(.top, 8)
                                
                                ScrollView{
                                    ForEach(tasks) { task in
                                        if(task.isCompleted == false){
                                            if(task.duedate! < Date().advanced(by: 172800)){
                                                TaskRow(task: task)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .frame(width: 300, height: 180)
                        .padding(.top, -10)
                    }
                    
                    Spacer()
                    
                    // TIMER
                    TimerControlView(timerValue: $timerValue, isTimerRunning: isTimerRunning, toggleTimer: toggleTimer).preferredColorScheme(.light)
                        .padding(.top)
                        .onTapGesture {
                            // START/STOP TIMER
                            toggleTimer()
                        }
                        .onLongPressGesture(minimumDuration: 0.1){
                            // TAG POPUP
                            showingtagPopup.toggle()
                        }
                        .sheet(isPresented: $showingTagView) {
                            TagsView()
                        }
                        .sheet(isPresented: $showingTaskView) {
                            TasksView()
                        }
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    HStack{
                        VStack{
                            FoodBar(targetDate: dogobj.last!.lastfed!.advanced(by: 86400))
                            Image("hunger")
                                .resizable()
                                .frame(width:18, height: 18)
                        }
                        
                        VStack{
                            ExpBar(expPoints: Int(dogobj.last!.experience), level: Int(dogobj.last!.level))
                            Text("Level \(getDogLevel(dog: dogobj.last!))")
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                                .frame(height: 18)
                                .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                        }
                        
                        VStack{
                            HapinessBar(hapiness: dogobj.last!.hapiness, targetDate: dogobj.last!.lasthappy!.advanced(by: 172800))
                            Image(systemName:"smiley")
                                .resizable()
                                .frame(width:18, height: 18)
                                .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors))!)
                        }
                    }
                    .offset(y: 35)
                    
                    Spacer()
                    
                    Button{
                        showingTagView.toggle()
                    } label: {
                        ZStack{
                            Rectangle()
                                .frame(width: 200, height: 50)
                                .foregroundColor(Color(hex: findHex(color: "Main Blue", hexColors: hexColors)))
                                .cornerRadius(10.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors))!, lineWidth: 2)
                                )
                            HStack{
                                Image(systemName: "tag.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                                    .padding(.trailing)
                                    .padding(.leading)
                                Text("Tags")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .fontDesign(.rounded)
                                    .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                                Spacer()
                            }
                            .frame(width: 200, height: 50)
                        }
                    }
                    .offset(y: 15)
                    
                    NavigationLink{
                        StatsView()
                    } label: {
                        ZStack{
                            Rectangle()
                                .frame(width: 200, height: 50)
                                .foregroundColor(Color(hex: findHex(color: "Main Blue", hexColors: hexColors)))
                                .cornerRadius(10.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors))!, lineWidth: 2)
                                )
                            HStack{
                                Image(systemName: "chart.pie.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                                    .padding(.trailing)
                                    .padding(.leading)
                                Text("Stats")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .fontDesign(.rounded)
                                    .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                                Spacer()
                            }
                            .frame(width: 200, height: 50)
                        }
                    }
                    .offset(y: 15)
                    .padding(.bottom)
                }
                if(showingtagPopup){
                    TagSelection(tagSelection: $tagSelection)
                        .offset(y:150)
                }
                
                if(isTimerRunning || isTimerPaused){
                    HStack{
                        Button{
                            if(isTimerRunning){
                                pauseTimer()
                            } else if(isTimerPaused){
                                startTimer()
                            }
                        } label: {
                            ZStack{
                                Rectangle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color(hex: findHex(color: "Main Blue", hexColors: hexColors)))
                                    .cornerRadius(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors))!, lineWidth: 2)
                                    )
                                Image(systemName: "playpause")
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                            }
                        }
                        .offset(x: -70)
                        
                        Button{
                            stopTimer()
                        } label: {
                            ZStack{
                                Rectangle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color(hex: findHex(color: "Main Blue", hexColors: hexColors)))
                                    .cornerRadius(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors))!, lineWidth: 2)
                                    )
                                Image(systemName: "trash.square")
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                            }
                        }
                        .offset(x: 70)
                    }
                    .offset(y: 50)
                }
                
                if(showingCompletedTimer){
                    ZStack{
                        CompletedTimerView()
                        ZStack{
                            Button{
                                withAnimation{
                                    showingCompletedTimer.toggle()
                                }
                            }label: {
                                Rectangle()
                                    .frame(width:100, height: 40)
                                    .foregroundColor(Color(hex: findHex(color: "Main Blue", hexColors: hexColors)))
                                    .cornerRadius(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color(hex: findHex(color: "Complement Blue", hexColors: hexColors))!, lineWidth: 2)
                                    )
                            }
                            Text("Dismiss")
                                .foregroundColor(Color(hex: findHex(color: "Beige", hexColors: hexColors)))
                        }
                        .offset(y: 120)
                    }
                }

            }
        }
        .onAppear(perform: {
            print("Found \(dogobj.count) Dogs")
            
            if(dogobj.count < 1){
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
                newDog.lasthappy = Date()
                
                try? viewContext.save()
            }
            
            for tag in tags{
                tagList.append(tag.name!)
            }
        })
        .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    print("Active")
                } else if newPhase == .inactive {
                    if(isTimerRunning){
                        stopTimer()
                    }
                } else if newPhase == .background {
                    print("Background")
                }
        }
    }

    // Timer Toggle
    private func toggleTimer() {
        isTimerRunning.toggle()
        
        if isTimerRunning {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    // Start Timer Function
    private func startTimer() {
        if(showingtagPopup){
            showingtagPopup.toggle()
        }
        
        timerLength = timerValue
        isTimerRunning = true
        isTimerPaused = false
        
        // Timer
        cancellable = Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                if timerValue > 0.0 {
                    timerValue -= 1.0
                } else {
                    // Timer reached zero, complete the timer
                    timerCompleted()
                }
            }
        print("Timer started")
    }
    
    // Stop/Pause Timer
    private func stopTimer() {
        cancellable?.cancel()
        cancellable = nil
        isTimerRunning = false
        timerValue = 0.0
        timerLength = 0.0
        print("Timer Stopped")
    }
    
    private func pauseTimer(){
        cancellable?.cancel()
        
        isTimerRunning = false
        isTimerPaused = true
        print("Timer Paused")
    }
    
    // Timer Completed Function
    private func timerCompleted() {
        print("Timer completed")
        
        cancellable?.cancel()
        cancellable = nil
        isTimerRunning = false
        
        //You get 2 coins for every minute
        dogobj.last!.coins = dogobj.last!.coins + Int16(timerLength/30)
        //You get 1 exp for every minute
        dogobj.last!.experience = dogobj.last!.experience + Int16(timerLength/60)
        
        //New Timer Creation
        let newTimer = CompletedTimers(context: viewContext)
        
        newTimer.id = UUID()
        newTimer.timestamp = Date()
        newTimer.length = Float(timerLength)
        newTimer.coins = Int16(timerLength/30)
        newTimer.tag = tagSelection
        
        for tag in tags {
            if(tag.name! == tagSelection){
                tag.coinsNum = tag.coinsNum + newTimer.coins
                tag.timerNum = tag.timerNum + 1
                tag.timerTime = tag.timerTime + Int16(newTimer.length)
                tag.expNum = tag.expNum + Int16(timerLength/60)
            }
        }
        
        showingCompletedTimer.toggle()
        
        try? viewContext.save()
        
        print("Created New Completed Timer")
        print("Date of Creation: \(newTimer.timestamp ?? Date())")
        print("Length of Timer: \(newTimer.length)")
        print("Coins Earned: \(newTimer.coins)")
        print("Exp Earned: \(timerLength/60)")
        print("Tag: \(newTimer.tag ?? "n/a")")
    }
    
    private func updateTime() {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            currentTime = formatter.string(from: Date())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
