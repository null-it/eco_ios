//
//  MapViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import MapKit

class CustomPointAnnotation: MKPointAnnotation { // !
    var pinCustomImageName:String!
    var action: (()->())?
}


class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationDelta: Double = 5
    var presenter: MapPresenterProtocol!
    var configurator: MapConfiguratorProtocol!
    var isAuthorized: Bool = false {
        didSet {
            pinImageName = isAuthorized
                ? "mapPinBlue"
                : "mapPinGreen"
            selectedPinImageName = isAuthorized
                ? "mapPinPink"
                : "mapPinDarkBlue"
        }
    }
    
    var pinImageName: String!
    var selectedPinImageName: String!

    
    lazy var pointAnnotations: [CustomPointAnnotation] = []
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(MapViewController.hideInfoView))
        tapGesture.delegate = self
        return tapGesture
    }()
    
    lazy var infoView: WashingInfoView = {      
        let infoView: WashingInfoView = .fromNib()!
        view.addSubview(infoView)
        infoView.presenter = presenter
        infoView.isHidden = true
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(MapViewController.hideInfoView))
        swipeGesture.direction = .down
        infoView.addGestureRecognizer(swipeGesture)
        
        var frame = infoView.frame
        frame.size.width = view.frame.width
        if let tabBarHeight = self.tabBarController?.tabBar.frame.height {
            frame.size.height += tabBarHeight
        }
        infoView.frame = frame
        
        infoView.layer.cornerRadius = 24 // !
        if #available(iOS 11.0, *) {
            infoView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        return infoView
    }()
    
    // MARK: -  Lifecycle
    
    override func viewDidLoad() {
        configureMap()
        configureNavigationBar()
        set(latitude: 51.4, longitude: 39.11, action: { [weak self] in
            self?.presenter.didSelectPoint()
        })
        set(latitude: 50, longitude: 40, action: { [weak self] in
            self?.presenter.didSelectPoint()
        })
        set(latitude: 50, longitude: 30, action: { [weak self] in
            self?.presenter.didSelectPoint()
        })
        set(latitude: 54, longitude: 39, action: { [weak self] in
            self?.presenter.didSelectPoint()
        })
    }
    

    // MARK: -  Configurators
    
    private func configurePinAnnotation() -> CustomPointAnnotation {
        let pointAnnotation = CustomPointAnnotation()
        pointAnnotation.pinCustomImageName = pinImageName
        //        pointAnnotation.title = ""
        //        pointAnnotation.sub                                                                                                                                                                                                                                                                                                                                                                                                                                                                            = ""
        let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
        
        
        
        mapView.addAnnotation(pinAnnotationView.annotation!)
        return pointAnnotation
    }
    
    
    private func configureMap() {
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
    }
    
    
    private func set(latitude: Double, longitude: Double, action: (()->())?) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: locationDelta,
                                    longitudeDelta: locationDelta)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude,
                                                                       longitude: longitude),
                                        span: span)
        mapView.setRegion(region, animated: true)
        let pointAnnotation = configurePinAnnotation()
        pointAnnotation.coordinate = location

        let action = { [weak self] in
            action?()
            self?.setVisible(region: region) 
        }

        pointAnnotation.action = action
        
        
        pointAnnotations.append(pointAnnotation)
    }
    
    
    private func move(up: Bool, completion: (()->())? = nil) {
        var y = self.view.frame.height
        y -= up ? self.infoView.frame.height : 0
    
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.infoView.frame.origin = CGPoint(x: 0, y: y)
        }) { (_) in
            completion?()
        }
    }
    
    private func setVisible(region: MKCoordinateRegion) { // !
//        let rect = mapView.convert(region, toRectTo: view)
//        let mapRect = MKMapRect(x: Double(rect.minX),
//                                y: Double(rect.minY),
//                                width: Double(rect.width),
//                                height: Double(rect.height))
//        mapView.setVisibleMapRect(mapRect, animated: true)
        
//        mapView.setRegion(region, animated: true) // ! no
    }
    
    private func configureNavigationBar() {
        if !isAuthorized {
            createBackButton()
            title = "Где купить карту"
        }
        
//        createSkipButton()
    }
    
}

//MARK: - MapViewProtocol

extension MapViewController: MapViewProtocol {
    
    func showInfo() {
        // update infoView content
        guard infoView.isHidden else { return }
        infoView.isHidden = false
        infoView.frame.origin = CGPoint(x: 0, y: view.frame.height)
        mapView.addGestureRecognizer(tapGesture)
        move(up: true)
    }
    
    
    @objc func hideInfoView() {
        guard !infoView.isHidden else { return }
        move(up: false) { [weak self] in
            self?.infoView.isHidden = true
        }
        mapView.removeGestureRecognizer(tapGesture)
        mapView.selectedAnnotations.forEach { (annotation) in
            mapView.deselectAnnotation(annotation, animated: true)
        }
    }
    
    
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate  {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        if let customPointAnnotation = annotation as? CustomPointAnnotation {
            annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)
        }
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? CustomPointAnnotation {
            annotation.action?()
            view.image = UIImage(named: selectedPinImageName)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: pinImageName)
    }
}


// MARK: - UIGestureRecognizerDelegate

extension MapViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == tapGesture,
            let touchView = touch.view,
            let gestureRecognizerView = gestureRecognizer.view {
            let isMapView = touchView.isDescendant(of: gestureRecognizerView)
            let pin = touchView as? MKAnnotationView
            let isPin = pin != nil
            let isSelected = pin?.isSelected ?? false
            return isMapView && !isPin && !isSelected
        }
        return true
    }

}


// MARK: - NavigationBarConfigurationProtocol

extension MapViewController: NavigationBarConfigurationProtocol {
    
    func backButtonPressed() {
        presenter.popView()
    }
    
//
//    func skipButtonPressed() {
//        let reviewView: ReviewView = .fromNib()!
//        view.addSubview(reviewView)
//        let y = view.frame.height - reviewView.frame.height
//        let origin = CGPoint(x: 0, y: y)
//        var size = reviewView.frame.size
//        size.width = view.frame.width
//        let frame = CGRect(origin: origin, size: size)
//        reviewView.frame = frame
//    }

}
