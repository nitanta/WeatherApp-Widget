//
//  WeatherService.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/7/21.
//

import Combine
import Foundation

/// Protocol for handling network response
protocol WeatherServiceProtocol {
    func getWeather(latitude: Float, longitude: Float) -> AnyPublisher<Data, Error>
}


class WeatherService: WeatherServiceProtocol {
    private var bag = Set<AnyCancellable>()
    private let apiProvider = APIProvider<AppEndpoint>()
        
    init() {}
    
    func getWeather(latitude: Float, longitude: Float) -> AnyPublisher<Data, Error> {
        return apiProvider.getData(
            from: .getWheather(latitude: latitude, longitude: longitude)
        )
        .eraseToAnyPublisher()
    }
    
}
