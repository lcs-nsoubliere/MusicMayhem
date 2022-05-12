//
//  String.swift
//  MusicMayhem
//
//  Created by Noah Alexandre Soubliere on 2022-05-12.
//

import Foundation

extension String {

    init?(htmlEncodedString: String) {

        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        self.init(attributedString.string)

    }

}

let encodedString = "The Weeknd <em>&#8216;King Of The Fall&#8217;</em>"
let decodedString = String(htmlEncodedString: encodedString)
