//
//  SettingsView.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/20/23.
//

import SwiftUI



struct SettingsView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.scenePhase) var scenePhase
    @FetchRequest(sortDescriptors: [], animation: .default) var completedtimers: FetchedResults<CompletedTimers>
    @FetchRequest(sortDescriptors: [], animation: .default) var dogobj: FetchedResults<Dog>
    
    var body: some View {
        GodToolbar()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
