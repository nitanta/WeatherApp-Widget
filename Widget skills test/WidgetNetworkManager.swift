//
//  WidgetNetworkManager.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/8/21.
//
import Foundation
import Combine
import CoreLocation

class WidgetNetworkManager {
    
    private var bag = Set<AnyCancellable>()
    let service: WeatherServiceProtocol
    
    init(service: WeatherServiceProtocol) {
        self.service = service
    }
    
    func fetchData(location: CLLocationCoordinate2D, completion: @escaping (WheatherResponse) -> Void) {
        service.getWeather(latitude: Float(location.latitude), longitude: Float(location.longitude))
            .decode(type: ResponseOutput<WheatherResponse>.self, decoder: Container.jsonDecoder)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {  (_) in }) {  (output) in
                switch output {
                case .success(let response):
                    completion(response)
                case .failure: break
                }
            }.store(in: &bag)
    }
}
