//
//  WidgetLocationManager.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/8/21.
//

import CoreLocation
import Foundation

/// Handles location fetch and update.
class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager: CLLocationManager
    private var handler: ((Result<CLLocationCoordinate2D, Error>) -> Void)?

    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.setupLocation()
    }
    
    func setupLocation() {
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
        self.locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.locationManager.stopUpdatingLocation()
        self.handler?(.success(location.coordinate))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.handler?(.failure(NSError(domain: "", code: 111, userInfo: [
                                        NSLocalizedDescriptionKey: "Could not update location."])))
        debugPrint("Could not update location.", error.localizedDescription)
    }
}
