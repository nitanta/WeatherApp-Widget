//
//  WidgetLocationManager.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/8/21.
//

import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    private var handler: ((Result<CLLocationCoordinate2D, Error>) -> Void)?

    override init() {
        super.init()
        DispatchQueue.main.async {
            self.setupLocation()
        }
    }
    
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
    
    func fetchLocation(handler: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        self.handler = handler
        self.locationManager?.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.handler?(.success(location.coordinate))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.handler?(.failure(error))
        debugPrint("Could not update location.", error.localizedDescription)
    }
}
