//
//  ButtonStyles.swift
//  Pomodoro
//
//  Created by Luis Amorim on 26/02/25.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(minWidth: 100, minHeight: 20)
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(30)
            .shadow(radius: 2, x: 2, y: 2)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 100, minHeight: 20)
            .font(.headline)
            .padding()
            .background(.tertiary)
            .foregroundColor(.accentColor)
            .cornerRadius(30)
    }
}

#Preview {
    TimerView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
