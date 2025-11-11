//
//  GenModesl.swift
//  SwiftQuizFoundationModel
//
//  Created by Weerawut Chaiyasomboon on 11/11/2568.
//

import Foundation
import FoundationModels

@Generable
struct Quiz {
    @Guide(description: "The title of the quiz, for example 'Swift Fundamental' or 'Concurrency in Swift'. This help to identify the topic or focus area of the quiz")
    let title: String
    
    @Guide(description: "An array of Quiz's questions related to selected topic. Each question includes text and point values define in the Question model")
    let questions: [Question]
    
    @Guide(
        description: """
        The total number of points a user can earn by completing the entire quiz.
        """
    )
    let totalPoints: Int
}

@Generable
struct Question {
    @Guide(description: "A unique identifier of question, use to track or reference it")
    let questionId: Int
    
    @Guide(
        description: """
        The text of the question being asked.
        Example: 'Which keyword is used to declare a constant in Swift?'
        """
    )
    let text: String
    
    @Guide(
        description: """
        How many points this question is worth. Higher difficulty may give more points.
        For example: easy = 5, medium = 10, hard = 15. But normally must be 10 for example.
        """
    )
    let point: Int
    
    @Guide(
        description: """
        A list of possible answers the user can choose from.
        Typically 3–5 options. One option must be correct.
        """
    )
    let choices: [Choice]
    
}

@Generable
struct Choice {
    @Guide(description: "A unique identifier of choice, use to track or reference it")
    let choceId: Int
    
    @Guide(
        description: """
        The text of the answer choice shown to the user, such as 'A struct is a value type' or 'Classes are copied when apply' .
        """
    )
    let text: String
    
    @Guide(description: "Indicate whelter this choice is the correct answer to the question, set to 'true' for the right answer and 'false' otherwise")
    let isCorrect: Bool
}
