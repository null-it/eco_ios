//
//  MapViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import MapKit

class CustomPointAnnotation: MKPointAnnotation { //
    var pinCustomImageName:String!
}


class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    let locationDelta: Double = 5
    var presenter: MapPresenterProtocol!
    var configurator: MapConfiguratorProtocol!
    
    lazy var pinAnnotationView =  MKPinAnnotationView()
    lazy var pointAnnotations: [CustomPointAnnotation] = []
    
    // MARK: -  Lifecycle
    
    override func viewDidLoad() {
        configureMap()
    }
    
    
    override func viewDidAppear(_ animated: Bool) { //
        setCoordinates(latitude: 51.4, longitude: 39.11)
        setCoordinates(latitude: 50, longitude: 40)
    }
    
    
    // MARK: -  Configurators
    
    private func configurePinAnnotation() -> CustomPointAnnotation {
        let pointAnnotation = CustomPointAnnotation()
        pointAnnotation.pinCustomImageName = "mapPin"
        //        pointAnnotation.title = ""
        //        pointAnnotation.subtitle = ""
        pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
        mapView.addAnnotation(pinAnnotationView.annotation!)
        return pointAnnotation
    }
    
    
    private func configureMap() {
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
    }
    
    
    private func setCoordinates(latitude: Double, longitude: Double) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: locationDelta,
                                    longitudeDelta: locationDelta)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude,
                                                                       longitude: longitude),
                                        span: span)
        mapView.setRegion(region, animated: true)
        let pointAnnotation = configurePinAnnotation()
        pointAnnotation.coordinate = location
        pointAnnotations.append(pointAnnotation)
    }
    
}

//MARK: - MapViewProtocol

extension MapViewController: MapViewProtocol {
    
    
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate  {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if let customPointAnnotation = annotation as? CustomPointAnnotation {
            annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)
        }
        return annotationView
    }
    
}
