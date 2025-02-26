//
//  TimerAttribuites.swift
//  Pomodoro
//
//  Created by Luis Amorim on 26/02/25.
//

import ActivityKit
import SwiftUI

struct TimerAttribuites: ActivityAttributes {
    public typealias TimerStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var endTime: Date
    }
}
