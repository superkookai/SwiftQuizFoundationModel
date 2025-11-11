//
//  QuizScreen.swift
//  SwiftQuizFoundationModel
//
//  Created by Weerawut Chaiyasomboon on 11/11/2568.
//

import SwiftUI

struct QuizScreen: View {
    let topic: String
    
    @State private var quizStore = QuizStore()
    @State private var userSelections: [Int:Int] = [:]
    
    @State private var showSummary = false
    
    var canBeGraded: Bool {
        userSelections.count == quizStore.quiz?.questions?.count && !userSelections.isEmpty
    }
    
    
    var body: some View {
        Group {
            if let quiz = quizStore.quiz, let questions = quiz.questions {
                List(questions) { question in
                    let userSelectedChoiceId = userSelections[question.questionId ?? -1] ?? 0
                    
                    QuestionView(question: question)
                    
                    if let choices = question.choices {
                        ForEach(choices) { choice in
                            ChoiceView(choice: choice, userSelectedChoiceId: userSelectedChoiceId) { selectedChoice in
                                if let questionId = question.questionId {
                                    userSelections[questionId] = selectedChoice.choceId
                                }
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                }
                .listStyle(.plain)
                .toolbar(content: {
                    ToolbarItem {
                        Button {
                            quizStore.checkGrade(userSelections: userSelections)
                            showSummary = true
                        } label: {
                            Text("Submit")
                        }
                        .modifier(ButtonTint(isFinished: canBeGraded))
                    }
                })
            } else {
                ProgressView("Creating quiz...")
            }
        }
        .navigationTitle(topic.capitalized)
        .task {
            do {
                try await quizStore.buildQuiz(topic: topic)
            } catch {
                print("DEBUG: Error generated Quiz: \(error.localizedDescription)")
            }
        }
        .sheet(isPresented: $showSummary) {
            if let grade = quizStore.grade {
                SummaryView(topic: topic, grade: grade)
                    .presentationDetents([.fraction(0.25)])
            } else {
                Text("Error: No Grade!!!")
                    .presentationDetents([.fraction(0.25)])
            }
        }
    }
}

#Preview {
    NavigationStack {
        QuizScreen(topic: "Swift Concurrency")
    }
}

struct QuestionView: View {
    let question: Question.PartiallyGenerated
    
    var body: some View {
        HStack {
            if let id = question.questionId {
                Text("\(id)")
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.circle)
            }
            
            if let text = question.text {
                Text(text)
            }
        }
    }
}

struct ChoiceView: View {
    let choice: Choice.PartiallyGenerated
    let userSelectedChoiceId: Int
    let onselected: (Choice.PartiallyGenerated) -> Void
    
    var body: some View {
        HStack {
            if let choiceId = choice.choceId {
                Image(systemName: userSelectedChoiceId == choiceId ? "checkmark.circle.fill" : "circle")
                    .font(.title)
            }
            
            Text(choice.text ?? "None")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(.rect)
        .onTapGesture {
            onselected(choice)
        }
    }
}

struct ButtonTint: ViewModifier {
    let isFinished: Bool
    
    func body(content: Content) -> some View {
        if isFinished {
            content
                .buttonStyle(.borderedProminent)
        } else {
            content
                .disabled(!isFinished)
        }
    }
}

struct SummaryView: View {
    let topic: String
    let grade: Grade
    
    var body: some View {
        VStack {
            Text("Topic: \(topic.capitalized)")
                .font(.title)
            Text(grade.grade.uppercased())
                .font(.title)
                .bold()
                .foregroundStyle(.blue)
        }
    }
}
