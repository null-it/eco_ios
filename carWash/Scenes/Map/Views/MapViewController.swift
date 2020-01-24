//
//  MapViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    var pinCustomImageName: String!
    var action: (()->())?
    var id: Int?
    var text: String?
}


class MapViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var mapView: MKMapView!
    
    
     // MARK: - Properties
    
    let locationDelta: Double = 0.7
    var presenter: MapPresenterProtocol!
    var configurator: MapConfiguratorProtocol!
    var pinImageName: String!
    var selectedPinImageName: String!
    var isAuthorized: Bool = false {
        didSet {
            pinImageName = "mapPinDarkBlue" 
            selectedPinImageName = "mapPinGreen"
        }
    }
    
    lazy var pointAnnotations: [CustomPointAnnotation] = []
    
    lazy var tapGesture: UITapGestureRecognizer = {
        configureTapGestureRecognizer()
    }()
    
    lazy var infoView: WashingInfoView = {      
       configureWashingInfoView()
    }()
    
    lazy var activityView: UIView = {
        configureActivityView()
    }()
    
    
    // MARK: -  Lifecycle
    
    override func viewDidLoad() {
        configureMap()
        configureNavigationBar()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear()
    }
    
    // MARK: -  Private
    
    private func configureTapGestureRecognizer() -> UITapGestureRecognizer {
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(MapViewController.hideInfoView))
        tapGesture.delegate = self
        return tapGesture
    }
    
    private func configureWashingInfoView() -> WashingInfoView {
        let infoView: WashingInfoView = .fromNib()!
        infoView.isSalesViewHidden = !isAuthorized
        view.addSubview(infoView)
        infoView.presenter = presenter
        infoView.isHidden = true
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(MapViewController.hideInfoView))
        swipeGesture.direction = .down
        infoView.addGestureRecognizer(swipeGesture)
        var frame = infoView.frame
        frame.size.width = view.frame.width
        infoView.frame = frame
        infoView.heightChanged = { [weak self] (frameHeight) in
            guard let self = self else { return }
            var y = self.view.frame.height - frameHeight
            if let tabBarHeight = self.tabBarController?.tabBar.frame.height {
                y -= tabBarHeight
            }
            infoView.frame.origin.y = y
        }
        infoView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner],
                              radius: 24) // !
        
        return infoView
    }
    
    
    private func configureActivityView() -> UIView {
        let activityView = UIView()
        let currentWindow = UIApplication.shared.keyWindow!
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.widthAnchor.constraint(equalToConstant: currentWindow.frame.width).isActive = true
        activityView.heightAnchor.constraint(equalToConstant: currentWindow.frame.height).isActive = true
        
        activityView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        let activityIndicator = UIActivityIndicatorView()
        
        activityView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: activityView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: activityView.centerYAnchor).isActive = true
        
        activityIndicator.startAnimating()
        activityIndicator.color = .black
        return activityView
    }
    
    
    private func configurePinAnnotation() -> CustomPointAnnotation {
        let pointAnnotation = CustomPointAnnotation()
        pointAnnotation.pinCustomImageName = pinImageName
//        let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
//        mapView.addAnnotation(pinAnnotationView.annotation!)
        return pointAnnotation
    }
    
    
    private func configureMap() {
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
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

    
    private func configureNavigationBar() {
        if !isAuthorized {
            createBackButton()
            title = "Где купить карту"
        } else {
            createExitButton()
        }
        createLocationButton()
    }
    
}

//MARK: - MapViewProtocol

extension MapViewController: MapViewProtocol {
    
    func requestDidSend() {
        view.addSubview(activityView)
    }
    
    func responseDidRecieve() {
        activityView.removeFromSuperview()
    }
    
    func configureDefaultMode(latitude: Double, longitude: Double) {
        let span = MKCoordinateSpan(latitudeDelta: locationDelta,
                                    longitudeDelta: locationDelta)
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude,
                                                longitude: longitude)
        let region = MKCoordinateRegion(center: coordinate,
                                        span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    func configureSelectedWashMode() {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = nil
        createBackButton()
        title = "Мойки в городе"
    }
    
    
    func selectWash(id: Int) {
        let annotaions = pointAnnotations.filter { (annotation) -> Bool in
            annotation.id == id
        }
        if let annotaion = annotaions.first {
            mapView.selectAnnotation(annotaion, animated: true)
            let span = MKCoordinateSpan(latitudeDelta: locationDelta,
                                        longitudeDelta: locationDelta)
            let coordinate = CLLocationCoordinate2D(latitude: annotaion.coordinate.latitude - locationDelta / 4,
                                                    longitude: annotaion.coordinate.longitude)
            let region = MKCoordinateRegion(center: coordinate,
                                            span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func showInfo(address: String, cashback: String, sales: [StockResponse]) {
        infoView.set(address: address, cashback: cashback, sales: sales)
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
    
    
    func set(latitude: Double, longitude: Double, id: Int, cashbackText: String, action: (()->())?) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        let pointAnnotation = configurePinAnnotation()
        pointAnnotation.coordinate = location
        pointAnnotation.action = action
        pointAnnotation.id = id
        pointAnnotation.text = cashbackText
        
        let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
        mapView.addAnnotation(pinAnnotationView.annotation!)

        pointAnnotations.append(pointAnnotation)
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
            let label = UILabel()
//            label.frame.size = CGSize(width: 21, height: 19)
//            label.frame.origin = CGPoint(x: MapViewConstants.pinXOrigin,
//                                         y: MapViewConstants.pinYOrigin)
           
            label.textColor = .white
            label.text = customPointAnnotation.text
            label.font =  UIFont.systemFont(ofSize: 12, weight: .bold) 
            label.tag = MapViewConstants.pinLabelTag
            label.sizeToFit()
            
            let x =  (annotationView!.frame.width - label.frame.width) / 2
            let y = MapViewConstants.pinYOrigin
            label.frame.origin = CGPoint(x: x, y: y)
            
            annotationView?.subviews.forEach({ $0.removeFromSuperview() })
            annotationView?.addSubview(label)
            //            label.center = annotationView!.center
        }
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? CustomPointAnnotation {
            annotation.action?()
            view.image = UIImage(named: selectedPinImageName)
            if let label = view.viewWithTag(MapViewConstants.pinLabelTag) as? UILabel {
                label.font = label.font.withSize(15)
//                label.frame.origin = CGPoint(x: MapViewConstants.selectedPinXOrigin,
//                                             y: MapViewConstants.selectedPinYOrigin)
                label.sizeToFit()
                let x =  (view.frame.width - label.frame.width) / 2
                let y = MapViewConstants.selectedPinYOrigin
                label.frame.origin = CGPoint(x: x,
                                             y: y)
                
            }
            
            
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: pinImageName)
        if let label = view.viewWithTag(MapViewConstants.pinLabelTag) as? UILabel {
            label.font = label.font.withSize(12)
            label.sizeToFit()
            let x =  (view.frame.width - label.frame.width) / 2
            let y = MapViewConstants.pinYOrigin
            label.frame.origin = CGPoint(x: x, y: y)
        }
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
    
    @objc func backButtonPressed() {
        presenter.popView()
    }
    
    @objc func exitButtonPressed() {
        presenter.logout()
    }

    @objc func locationButtonPressed() {
        presenter.selectCity() { [weak self] in
            self?.hideInfoView()
        }
    }
    
}
