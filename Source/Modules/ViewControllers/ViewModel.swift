//
//  ViewModel.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/7/21.
//

import Foundation
import Combine
import UIKit
import CoreLocation

final class ViewModel: NSObject, ObservableObject {
    
    var isLoading: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    var error: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    var datasource: CurrentValueSubject<WheatherResponse?, Never> = CurrentValueSubject(nil)

    private var bag = Set<AnyCancellable>()
    
    let weatherService: WeatherServiceProtocol!
    var locationManager = LocationManager()
    
    init(service: WeatherServiceProtocol) {
        self.weatherService = service
        super.init()
    }
    
    func getLocationAndWeather(finished: (() -> Void)? = nil) {
        if datasource.value == nil {
            self.isLoading.send(true)
        }
        self.locationManager.fetchLocation { [weak self] (location) in
            guard let self = self else { return }
            switch location {
            case .success(let coord):
                self.getWeatherData(coordinate: coord, finished: finished)
            case .failure(let error):
                self.error.send(error.localizedDescription)
            }
        }
    }
    
    private func getWeatherData(coordinate: CLLocationCoordinate2D, finished: (() -> Void)? = nil) {
        weatherService.getWeather(latitude: Float(coordinate.latitude), longitude: Float(coordinate.longitude))
            .decode(type: ResponseOutput<WheatherResponse>.self, decoder: Container.jsonDecoder)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] (completion) in
                guard let self = self else { return }
                self.isLoading.send(false)
                switch completion {
                case .failure(let error):
                    self.error.send(error.localizedDescription)
                case .finished: break
                }
                finished?()
            }) { [weak self] (output) in
                guard let self = self else { return }
                switch output {
                case .success(let response):
                    self.datasource.send(response)
                case .failure(let error):
                    self.error.send(error.message)
                }
                finished?()
            }.store(in: &bag)
    }
}
