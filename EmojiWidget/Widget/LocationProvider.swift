//
//  LocationProvider.swift
//  WidgetExtension
//
//  Created by Andrea Stevanato on 23/07/2020.
//

import CoreLocation

class LocationProvider: NSObject, CLLocationManagerDelegate, ObservableObject {

    var locationManager: CLLocationManager!
    var lastLocation: CLLocationCoordinate2D?

    override init() {}

    func setup() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestLocation()
    }

    // MARK: CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.lastLocation = locations.last?.coordinate
        print("locationManager didUpdateLocations \(locations.last.debugDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager didFailWithError \(error.localizedDescription)")
    }
}
