//
//  ContentView.swift
//  Pomodoro
//
//  Created by Luis Amorim on 26/02/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TimerView()
                .tabItem {
                    Image(systemName: "timer")
                    Text("Timer")
                }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("History")
                }
        }
    }
}

#Preview{
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
