//
//  Container.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/7/21.
//

import Foundation

//MARK: Used for parsing network response
class Container {
    static let jsonDecoder: JSONDecoder = JSONDecoder()
    static let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
}
