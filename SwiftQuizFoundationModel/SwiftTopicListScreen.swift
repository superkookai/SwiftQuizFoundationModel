//
//  ContentView.swift
//  SwiftQuizFoundationModel
//
//  Created by Weerawut Chaiyasomboon on 11/11/2568.
//

import SwiftUI
import FoundationModels


struct SwiftTopicListScreen: View {
    let topics = [
        "Swift Basics & Syntax",
        "Operators",
        "Control Flow",
        "Functions & Closures",
        "Optionals",
        "Collections",
        "Strings & Characters",
        "Structs & Enums",
        "Classes & OOP Basics",
        "Error Handling"
    ]
    
    var body: some View {
        NavigationStack {
            List(topics, id: \.self) { topic in
                NavigationLink {
                    QuizScreen(topic: topic)
                } label: {
                    Text(topic.capitalized)
                        .font(.title3)
                }
            }
            .navigationTitle("Swift Topics")
            .listStyle(.plain)
        }
    }
}

#Preview {
    SwiftTopicListScreen()
}
