//
//  TimerAttributes.swift
//  Pomodoro
//
//  Created by Luis Amorim on 26/02/25.
//

import ActivityKit
import SwiftUI

struct TimerAttributes: ActivityAttributes {
    public typealias TimerStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var endTime: Double
    }
    var pause: Bool = false
}
