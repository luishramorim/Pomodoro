//
//  PomodoroApp.swift
//  Pomodoro
//
//  Created by Luis Amorim on 26/02/25.
//

import SwiftUI

@main
struct PomodoroTimerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
