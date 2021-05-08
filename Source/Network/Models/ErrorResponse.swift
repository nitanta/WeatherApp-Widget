//
//  ErrorResponse.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/7/21.
//

struct ErrorResponse: Codable {
    let code: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "cod"
        case message
    }
}
