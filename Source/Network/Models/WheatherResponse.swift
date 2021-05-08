//
//  WheatherResponse.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/7/21.
//

import Foundation

struct WheatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let sys: Sys
    let name: String
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Sys: Codable {
    let country: String
    let sunrise, sunset: Int
}

struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
