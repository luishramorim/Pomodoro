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
    let context: ActivityViewContext<TimerAttribuites>
    
    var body: some View {
        VStack{
            Text(context.state.endTime, style: .timer)
                .font(.headline)
        }
    }
}

@main
struct PomodoroWidget: Widget {
    let kind: String = "PomodoroWidget"

    var body: some WidgetConfiguration {
        ActivityConfiguration(attributesType: TimerAttribuites.self ) { context in
            TimerActivityView(context: context)
        }
    }
}
