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
    var background: CurrentValueSubject<UIImage?, Never> = CurrentValueSubject(nil)
    var currentLocation: CurrentValueSubject<CLLocationCoordinate2D?, Never> = CurrentValueSubject(nil)

    private var bag = Set<AnyCancellable>()
    
    let weatherService: WeatherServiceProtocol!
    var locationManager: CLLocationManager!
    
    init(service: WeatherServiceProtocol) {
        self.weatherService = service
        super.init()
        self.setupLocation()
    }
    
    func getWeatherData(finished: (() -> Void)? = nil) {
       // guard let location = currentLocation.value else { return }
        self.isLoading.send(true)
        weatherService.getWeather(latitude: Float(35.0), longitude: Float(139.0))
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

extension ViewModel: CLLocationManagerDelegate {
    
    func setupLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        switch locationManager.authorizationStatus {
        case .denied, .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        default: break
        }
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.currentLocation.send(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error.send(error.localizedDescription)
    }
}

