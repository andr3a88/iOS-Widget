//
//  MapView.swift
//  iOS14-Widget
//
//  Created by Andrea Stevanato on 23/07/2020.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {

    var locationManager = CLLocationManager()

    func makeUIView(context: Context) -> MKMapView {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let userLocationCoordinate = self.locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocationCoordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            uiView.setRegion(viewRegion, animated: true)
        }
    }
}
