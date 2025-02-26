//
//  HistoryView.swift
//  Pomodoro
//
//  Created by Luis Amorim on 26/02/25.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.startDate, ascending: false)],
        animation: .default)
    private var sessions: FetchedResults<Session>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sessions) { session in
                    VStack(alignment: .leading) {
                        Text("Session: \(session.startDate ?? Date(), formatter: dateFormatter)")
                            .font(.headline)
                        if let start = session.startDate, let end = session.endDate {
                            Text("^[\(Int(end.timeIntervalSince(start)) / 60) minute](inflect: true)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Sessions")
        }
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()
