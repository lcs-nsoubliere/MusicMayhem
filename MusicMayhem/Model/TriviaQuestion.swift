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
struct TriviaQuestion: Decodable, Hashable, Encodable {
    let id: String
    let question: String
    let status: Int
}
