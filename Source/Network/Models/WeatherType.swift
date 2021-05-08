//
//  WeatherType.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/8/21.
//

import Foundation

enum WeatherType {
    case clouds(String)
    case thunderStorm
    case drizzle
    case rain
    case snow
    case sunny
    
    init(raw: String, desc: String) {
        switch raw {
        case "Clouds": self = .clouds(desc)
        case "Thunderstorm": self = .thunderStorm
        case "Drizzle": self = .drizzle
        case "Rain": self = .rain
        case "Snow": self = .snow
        case "Clear": self = .sunny
        default: self = .sunny
        }
    }
    
    var imageName: String {
        switch self {
        case .clouds(let desc):
            if desc == "overcast clouds" {
                return "ic-cloudy"
            }
            return "ic-partlycloudy"
        case .drizzle, .rain, .thunderStorm: return "ic-rainy"
        case .snow: return "ic-snowy"
        case .sunny: return "ic-sunny"
        }
    }
}
