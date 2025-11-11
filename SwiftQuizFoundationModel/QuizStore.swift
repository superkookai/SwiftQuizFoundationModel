//
//  QuizStore.swift
//  SwiftQuizFoundationModel
//
//  Created by Weerawut Chaiyasomboon on 11/11/2568.
//

import Foundation
import FoundationModels

struct Instructions {
    static let quiz: String = """
        You are helpful Swift language quiz author.
        
        REQUIREMENTS:
        - Create exactly 5 Swift quiz questions about topic provided by user.
        - Each question has exactly 4 choices, with exactly 1 correct choice.
        - Each question's 'point' must be 10.
        - Provide unique, consecutive integer IDs starting at 1 for questionId and choiceId (per question).
        - Use upto date Swift terms (async/await, @MainActor, Sendable, SwiftUI, SPM, testing).
        
        OUTPUT: Fill the Quiz schema the client provided (no explanation, no answers outside 'isCorrect').
        
        RULES:
        - Keep stem short and unambiguous.
        - No code block unless essential (less than 1-2 lines).
        - Avoid deprecated API
        """
}

struct Grade {
    let scores: Int
    
    var grade: String {
        switch scores {
        case 45...50: "A"
        case 40...44: "B"
        case 35...39: "C"
        case 30...34: "D"
        default: "F"
        }
    }
}

@Observable
class QuizStore {
    let session: LanguageModelSession
    var quiz: Quiz.PartiallyGenerated?
    var grade: Grade?
    
    init() {
        session = LanguageModelSession(instructions: {
            Instructions.quiz //System Prompt
        })
        
        session.prewarm()
    }
    
    func buildQuiz(topic: String) async throws {
        let prompt = "Create a Swift Quiz with with 5 questions on \(topic)"
        let stream = session.streamResponse(to: prompt, generating: Quiz.self)
        for try await partialResponse in stream {
            quiz = partialResponse.content
        }
    }
    
    func checkGrade(userSelections: [Int: Int]) {
        var score = 0
        if let quiz, let questions = quiz.questions {
            for question in questions {
                let userSelectedId = userSelections[question.questionId ?? -1]
                if let choices = question.choices, let correctedId = choices.first(where: { $0.isCorrect == true })?.choceId, correctedId == userSelectedId {
                    score += question.point ?? 0
                }
            }
        }
        self.grade = Grade(scores: score)
    }
}
