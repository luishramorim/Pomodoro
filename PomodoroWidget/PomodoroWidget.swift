//
//  PomodoroWidget.swift
//  PomodoroWidget
//
//  Created by Luis Amorim on 26/02/25.
//

import WidgetKit
import SwiftUI
import ActivityKit

struct TimerActivityView: View {
    let context: ActivityViewContext<TimerAttributes>
    
    var body: some View {
        VStack {
            HStack{
                Text("Pomodoro")
                    .foregroundStyle(.accent)
                    .bold()
                
                Spacer()
            }
            
            HStack{
                Text(formattedTime(from: context.state.endTime))
                    .font(.system(size: 64, weight: .bold, design: .monospaced))
                    .contentTransition(.numericText(value: context.state.endTime))
                
                Spacer()
                
                Image(systemName: "arrow.clockwise.circle")
                    .font(.system(size: 48))
                    .foregroundStyle(.secondary)
                
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.accent)
            }
            

        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    func formattedTime(from seconds: Double) -> String {
        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let remainingSeconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

@main
struct PomodoroWidget: Widget {
    let kind: String = "PomodoroWidget"

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            TimerActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland(
                expanded: {
                    DynamicIslandExpandedRegion(.center) {
                        VStack {
                            Text("Pomodoro Timer")
                                .font(.headline)
                            Text(formattedTime(from: context.state.endTime))
                                .contentTransition(.numericText(value: context.state.endTime))
                                .font(.title2)
                        }
                    }
                },
                compactLeading: {
                    Text("🍅")
                },
                compactTrailing: {
                    Text(formattedTime(from: context.state.endTime))
                        .font(.caption2)
                },
                minimal: {
                    Text("🍅")
                }
            )
        }
    }
    
    func formattedTime(from seconds: Double) -> String {
        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let remainingSeconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}
