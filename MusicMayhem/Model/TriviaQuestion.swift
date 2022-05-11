//
//  TriviaQuestion.swift
//  MusicMayhem
//
//  Created by Noah Alexandre Soubliere on 2022-05-10.
//

import Foundation
// The TriviaQuestion structure conforms to the
// decodable protocol. This means that we want
// swift to be able to take a JSON object
// and "decode" into an instance of this
// structure
struct json_reader: Decodable, Hashable, Encodable {
    let response_code: Int
    let results: [TriviaQuestion]
}
                        
struct TriviaQuestion: Decodable, Hashable, Encodable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
}
