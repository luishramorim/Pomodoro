//
//  widgetLiveActivity.swift
//  widget
//
//  Created by Luis Amorim on 26/02/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct widgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        /// The remaining time for the timer in seconds.
        var remainingTime: Int
    }
    
    /// Fixed non-changing properties about your activity.
    var name: String
}

struct widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: widgetAttributes.self) { context in
            // Lock Screen/Banner UI
            VStack {
                Text(timeString(from: context.state.remainingTime))
                    .font(.headline)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: context.state.remainingTime)
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI regions for Dynamic Island.
                DynamicIslandExpandedRegion(.leading) {
                    // Optionally, you could include additional details here.
                    Text(timeString(from: context.state.remainingTime))
                }
                DynamicIslandExpandedRegion(.trailing) {
                    EmptyView()
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(timeString(from: context.state.remainingTime))
                        .transition(.opacity)
                        .animation(.easeInOut, value: context.state.remainingTime)
                }
            } compactLeading: {
                Text(timeString(from: context.state.remainingTime))
            } compactTrailing: {
                EmptyView()
            } minimal: {
                Text(timeString(from: context.state.remainingTime))
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
    
    /// Formats seconds into a "MM:SS" string.
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

extension widgetAttributes {
    fileprivate static var preview: widgetAttributes {
        widgetAttributes(name: "Pomodoro Timer")
    }
}

extension widgetAttributes.ContentState {
    // Example when the timer is running (e.g., 24 minutes and 30 seconds remaining).
    fileprivate static var timerActive: widgetAttributes.ContentState {
        widgetAttributes.ContentState(remainingTime: 1470)
    }
    
    // Example when the timer is not running (e.g., 0 seconds remaining).
    fileprivate static var timerInactive: widgetAttributes.ContentState {
        widgetAttributes.ContentState(remainingTime: 0)
    }
}

#Preview("Live Activity Active", as: .content, using: widgetAttributes.preview) {
    widgetLiveActivity()
} contentStates: {
    widgetAttributes.ContentState.timerActive
}

#Preview("Live Activity Inactive", as: .content, using: widgetAttributes.preview) {
    widgetLiveActivity()
} contentStates: {
    widgetAttributes.ContentState.timerInactive
}
