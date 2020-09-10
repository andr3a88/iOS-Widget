//
//  LocationProvider.swift
//  WidgetExtension
//
//  Created by Andrea Stevanato on 23/07/2020.
//

import CoreLocation
import MapKit
import SwiftUI

class LocationProvider: NSObject, CLLocationManagerDelegate, ObservableObject {

    var appleParkCoordinate = CLLocationCoordinate2D(latitude: 37.334735, longitude: -122.008986)
    var locationManager: CLLocationManager!
    var lastLocation: CLLocationCoordinate2D?

    override init() {}

    func setup() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestLocation()
    }

    func getMap(completion: @escaping (_ image: Image) -> Void) {
        self.getMapSnapshot { image in
            completion(image)
        }
    }

    func getMapSnapshot(completionHandler: @escaping (Image) -> Void) {
        let coordinate = self.locationManager.location?.coordinate ?? appleParkCoordinate
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        options.mapType = .satellite
        options.pointOfInterestFilter = MKPointOfInterestFilter(excluding: [.airport])
        let snapshot = MKMapSnapshotter(options: options)
        snapshot.start { (snapshot, error) in
            if let snapshotImage = snapshot?.image {
                completionHandler(Image(uiImage: snapshotImage))
            } else {
                completionHandler(Image("MapPlaceholder"))
            }
        }
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
