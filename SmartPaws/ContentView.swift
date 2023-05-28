import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.scenePhase) var scenePhase
    @FetchRequest(sortDescriptors: [], animation: .default) var completedtimers: FetchedResults<CompletedTimers>
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
                    .fill(Color.init(red: 255/255, green: 235/255, blue: 204/255))
                    .edgesIgnoringSafeArea(.all)
                
                Image("livingRoom")
                    .resizable()
                    .scaledToFill()
                    .offset(x: -1, y: -4)
                    
                DogObj()
                
                if(showingtagPopup){
                    ZStack { // 4
                        Rectangle()
                            .frame(width: 200, height: 30)
                            .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                            .border(.black, width: 3)
                        
                        Picker("Select a Tag", selection: $tagSelection){
                            ForEach(tagList, id: \.self){ tag in
                                Text(tag)
                            }
                        }
                        
                        
                    }
                    .offset(y:150)
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
                                    .border(.black, width:3)
                                    .foregroundColor(Color(hex: findHex(color: "Dark Brown", hexColors: hexColors)))
                                    .cornerRadius(5)
                            }
                            Text("Dismiss")
                        }
                        .offset(y: 120)
                    }
                }

                VStack(){
                    
                    // Hunger & Hapiness Bars
                    HStack{
                        VStack(alignment: .center){
                            HStack{
                                Image("hunger")
                                    .resizable()
                                    .frame(width:18, height: 18)
                                FoodBar(targetDate: dogobj.last!.lastfed!.advanced(by: 86400))
                            }
                            HStack{
                                Image(systemName:"smiley")
                                    .resizable()
                                    .frame(width:18, height: 18)
                                    .foregroundColor(.black)
                                HapinessBar(hapiness: dogobj.last!.hapiness)
                            }
                        }
                        .offset(x: 10, y: 20)
                        .frame(maxWidth: 120)
                        
                        Spacer()
                        
                        VStack(){
                            Text(currentTime)
                                .font(.system(size: 34))
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .onReceive(timeCurrent){ _ in
                                    updateTime()
                                }
                            Text(Date(), style: .date)
                                .font(.system(size: 14))
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .offset(y: 20)
                        
                        Spacer()
                        
                        // Setting & Store
                        VStack{
                            HStack{
                                NavigationLink{
                                    SettingsView()
                                }label: {
                                    ZStack{
                                        Circle()
                                            .frame(width: 55, height: 55)
                                            .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                                        Image(systemName: "gear.circle")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(.black)
                                    }
                                }
                                .offset(x: -7)
                                
                                NavigationLink{
                                    StoreView()
                                }label: {
                                    ZStack{
                                        Circle()
                                            .frame(width: 55, height: 55)
                                            .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                                        HStack{
                                            Image(systemName: "hockey.puck.circle")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(.black)
                                                .offset(x: 2.5)
                                            Text(String(dogobj.last!.coins))
                                                .foregroundColor(.black)
                                                .font(.system(size: 14))
                                                .offset(x: -2.5)
                                        }
                                    }
                                }
                            }
                            
                            NavigationLink{
                                StatsView()
                            } label: {
                                ZStack{
                                    Rectangle()
                                        .frame(width: 120, height: 30)
                                        .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                                        .cornerRadius(5)
                                    Image(systemName: "chart.pie")
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.black)
                                }
                            }
                            .offset(x: -2)
                        }
                        .offset(x: -10, y: 20)
                        .frame(maxWidth: 120)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                    
                    Spacer()
                
                    HStack{
                        Button{
                            showingTagView.toggle()
                        } label: {
                            ZStack{
                                Circle()
                                    .frame(width: 55, height: 55)
                                    .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                                Image(systemName: "tag")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.black)
                            }
                            
                        }
                        .offset(y: 250)
                        .padding(.leading)
                        
                        Spacer()
                        
                        // TIMER
                        TimerControlView(timerValue: $timerValue, isTimerRunning: isTimerRunning, toggleTimer: toggleTimer).preferredColorScheme(.light)
                            .onTapGesture {
                                // START/STOP TIMER
                                toggleTimer()
                            }
                            .offset(y: 250)
                            .onLongPressGesture(minimumDuration: 0.1){
                                // TAG POPUP
                                showingtagPopup.toggle()
                            }
                        
                        Spacer()
                        
                        Button{
                            showingTaskView.toggle()
                        } label: {
                            ZStack{
                                Circle()
                                    .frame(width: 55, height: 55)
                                    .foregroundColor(Color(hex: findHex(color: "Wood Brown", hexColors: hexColors)))
                                Image(systemName: "checkmark.square")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.black)
                            }
                        }
                        .offset(y: 250)
                        .padding(.trailing)                    }
                    .sheet(isPresented: $showingTagView) {
                        TagsView()
                    }
                    .sheet(isPresented: $showingTaskView) {
                        TasksView()
                    }
                    Spacer()
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
