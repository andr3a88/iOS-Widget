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


struct MapViewWidget: UIViewRepresentable {

    var locationManager = CLLocationManager()
    @Binding var mapSnapshot: Image

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewWidget

        init(_ parent: MapViewWidget) {
            self.parent = parent
        }

        func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {

            //setup whatever region you want to see :mapView.setRegion(region, animated: true)
            let render = UIGraphicsImageRenderer(size: mapView.bounds.size)
            let ratio = mapView.bounds.size.height / mapView.bounds.size.width
            let img = render.image { (ctx) in
                mapView.drawHierarchy(in: CGRect(x: 100, y: 100, width: 300, height: 300 * ratio), afterScreenUpdates: true)
            }
            DispatchQueue.main.async {
                self.parent.mapSnapshot = Image(uiImage: img)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        let t = mapView.screenshot
        DispatchQueue.main.async {
            self.mapSnapshot = Image(uiImage: t)
        }

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let userLocationCoordinate = self.locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocationCoordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            uiView.setRegion(viewRegion, animated: true)
        }
    }
}

extension UIView {

    func pb_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIView {

    var screenshot: UIImage{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        self.layer.render(in: context)
        guard let screenShot = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() };
        UIGraphicsEndImageContext()
        return screenShot
    }
}
