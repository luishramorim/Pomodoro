//
//  TimerView.swift
//  Pomodoro
//
//  Created by Luis Amorim on 26/02/25.
//

import SwiftUI
import CoreData
import UserNotifications
import ActivityKit

/// Defines the attributes for the timer live activity.
struct TimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        /// The remaining time in seconds.
        var remainingTime: Double
    }
    
    /// A simple attribute to identify the timer.
    var timerName: String
}

struct TimerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var timer: Timer? = nil
    @State private var chosenMinutes: Double = 25
    @State private var remainingTime: Double = 25 * 60
    @State private var isRunning: Bool = false
    @State private var startDate: Date? = nil

    /// Reference to the active live activity.
    @State private var timerActivity: Activity<TimerAttributes>?
    
    var totalTime: Double { chosenMinutes * 60 }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Gauge display with controls for adjusting the session duration.
                Gauge(value: remainingTime, in: 0...totalTime) {
                    HStack {
                        Spacer()
                        Button {
                            if !isRunning, chosenMinutes > 1 {
                                chosenMinutes -= 1
                                remainingTime = chosenMinutes * 60
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.title)
                                .shadow(radius: 2)
                        }
                        .disabled(chosenMinutes <= 1 || isRunning)
                        
                        Text(timeString(from: Int(remainingTime)))
                            .font(.system(size: 64, weight: .bold, design: .monospaced))
                            .contentTransition(.numericText(value: remainingTime))
                            .shadow(radius: 2)
                        
                        Button {
                            if !isRunning {
                                chosenMinutes += 1
                                remainingTime = chosenMinutes * 60
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .shadow(radius: 2)
                        }
                        .disabled(chosenMinutes >= 120 || isRunning)
                        
                        Spacer()
                    }
                }
                .gaugeStyle(.accessoryLinearCapacity)
                .tint(.accentColor)
                .animation(.easeInOut(duration: 1.0), value: remainingTime)
                
                // Control buttons for starting, pausing, and resetting the timer.
                HStack(spacing: 20) {
                    if !isRunning {
                        Button("Start") { startTimer() }
                            .buttonStyle(PrimaryButtonStyle())
                    } else {
                        Button("Pause") { pauseTimer() }
                            .buttonStyle(PrimaryButtonStyle())
                    }
                    Button("Reset") { resetTimer() }
                        .buttonStyle(SecondaryButtonStyle())
                }
            }
            .padding()
            .navigationTitle("Session Timer")
        }
        .onAppear {
            // Request authorization for local notifications.
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error {
                    print("Error requesting notification authorization: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Converts a given number of seconds into a formatted "MM:SS" string.
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }

    /// Starts the timer session and activates the live activity.
    func startTimer() {
        guard !isRunning else { return }
        startDate = Date()
        isRunning = true

        // Request a new live activity when the timer starts.
        let attributes = TimerAttributes(timerName: "Pomodoro Timer")
        let initialContentState = TimerAttributes.ContentState(remainingTime: remainingTime)
        do {
            timerActivity = try Activity<TimerAttributes>.request(
                attributes: attributes,
                contentState: initialContentState,
                pushType: nil
            )
        } catch {
            print("Error starting live activity: \(error.localizedDescription)")
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingTime > 0 {
                withAnimation(.easeInOut(duration: 1.0)) {
                    remainingTime -= 1
                }
                // Update the live activity with the new remaining time.
                if let activity = timerActivity {
                    let updatedContentState = TimerAttributes.ContentState(remainingTime: remainingTime)
                    Task {
                        await activity.update(using: updatedContentState)
                    }
                }
            } else {
                timer?.invalidate()
                isRunning = false
                recordSession()
                sendNotification()
                resetTimer()
            }
        }
    }

    /// Pauses the timer session.
    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
        // You may choose to update or end the live activity here if needed.
    }

    /// Resets the timer and ends the live activity.
    func resetTimer() {
        timer?.invalidate()
        remainingTime = totalTime
        isRunning = false
        
        // End the live activity if it is active.
        if let activity = timerActivity {
            Task {
                await activity.end(dismissalPolicy: .immediate)
            }
            timerActivity = nil
        }
    }

    /// Records the completed session in Core Data.
    func recordSession() {
        guard let start = startDate else { return }
        let newSession = Session(context: viewContext)
        newSession.id = UUID()
        newSession.startDate = start
        newSession.endDate = Date()
        do {
            try viewContext.save()
        } catch {
            print("Error saving session: \(error.localizedDescription)")
        }
    }

    /// Sends a local notification indicating that the session has ended.
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Session over"
        content.body = "Time to take a break!"
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    TimerView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
