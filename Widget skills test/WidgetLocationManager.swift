//
//  WidgetLocationManager.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/8/21.
//

import CoreLocation

class WidgetLocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    private var handler: ((CLLocationCoordinate2D) -> Void)?

    override init() {
        super.init()
        DispatchQueue.main.async {
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
            if self.locationManager?.authorizationStatus == .notDetermined {
                self.locationManager?.requestWhenInUseAuthorization()
            }
        }
    }
    
    func fetchLocation(handler: @escaping (CLLocationCoordinate2D) -> Void) {
        self.handler = handler
        self.locationManager?.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.handler?(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Could not update location.", error.localizedDescription)
    }
}
