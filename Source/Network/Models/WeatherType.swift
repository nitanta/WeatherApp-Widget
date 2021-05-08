//
//  WeatherType.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/8/21.
//

import Foundation

enum WeatherType: String {
    case clouds = "Clouds"
    case thunderStorm = "Thunderstorm"
    case drizzle = "Drizzle"
    case rain = "Rain"
    case snow = "Snow"
    case sunny = "Clear"
    
    var imageName: String {
        switch self {
        case .clouds: return "ic-cloudy"
        case .thunderStorm: return "ic-rainy"
        case .drizzle: return "ic-rainy"
        case .rain: return "ic-rainy"
        case .snow: return "ic-snowy"
        case .sunny: return "ic-sunny"
        }
    }
}
