//
//  SmartPawsApp.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/5/23.
//

import SwiftUI

@main
struct SmartPawsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
