//
//  MapViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import MapKit
import SkeletonView
import CoreLocation
import SwiftEntryKit

class CustomPointAnnotation: MKPointAnnotation {
    var action: (()->())?
    var id: Int?
    var text: String?
}


class MapViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - Properties
    
    let locationDelta: Double = 0.7
    let washLocationDelta: Double = 0.01
    var presenter: MapPresenterProtocol!
    var configurator: MapConfiguratorProtocol!
    var isAuthorized: Bool = false
    var isWashingStart: Bool = false
    var locationManager: CLLocationManager?
    
    lazy var pointAnnotations: [CustomPointAnnotation] = []
    
    lazy var tapGesture: UITapGestureRecognizer = {
        configureTapGestureRecognizer()
    }()
    
    lazy var infoView: WashingInfoView = {
        configureWashingInfoView()
    }()
    
    lazy var terminalView: TerminalView = {
        configureTerminalView()
    }()
    
    
    lazy var confirmationView: WashingStartConfirmationView = {
        configureConfirmationView()
    }()
    
    lazy var activityView: UIView = {
        configureActivityView()
    }()
    
    
    // MARK: -  Lifecycle
    
    override func viewDidLoad() { // -
        super.viewDidLoad()
        
        if !isWashingStart {
            infoView.frame.origin = CGPoint(x: 0, y: view.frame.height)
        }
        
        configureMap()
        configureBars()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isWashingStart {
            terminalView.frame.origin = CGPoint(x: 0, y: view.frame.height)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SwiftEntryKit.dismiss()
    }
    
    // MARK: -  Private
    
    private func configureTapGestureRecognizer() -> UITapGestureRecognizer {
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(MapViewController.hideBottomView)) // !
        tapGesture.delegate = self
        return tapGesture
    }
    
    private func configureWashingInfoView() -> WashingInfoView {
        let infoView: WashingInfoView = .fromNib()!
        infoView.isSalesViewHidden = !isAuthorized
        view.addSubview(infoView)
        infoView.presenter = presenter
        infoView.isHidden = true
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(MapViewController.hideBottomView))  // !
        swipeGesture.direction = .down
        infoView.addGestureRecognizer(swipeGesture)
        var frame = infoView.frame
        frame.size.width = view.frame.width
        infoView.frame = frame
        infoView.heightChanged = { [weak self] (frameHeight) in
            self?.updateInfoViewLayout(height: frameHeight)
        }
        infoView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 24) // !
        return infoView
    }
    
    private func configureConfirmationView() -> WashingStartConfirmationView {
        let confirmationView: WashingStartConfirmationView = .fromNib()!
        view.addSubview(confirmationView)
//        confirmationView.presenter = presenter
        confirmationView.isHidden = true
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(MapViewController.hideBottomView))  // !
        swipeGesture.direction = .down
        confirmationView.addGestureRecognizer(swipeGesture)
        var frame = confirmationView.frame
        frame.size.width = view.frame.width
        confirmationView.frame = frame
//        confirmationView.heightChanged = { [weak self] (frameHeight) in
//            self?.updateInfoViewLayout(height: frameHeight)
//        }
        mapView.addGestureRecognizer(tapGesture)
        confirmationView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 24) // !
        return confirmationView
    }
    
    private func configureTerminalView() -> TerminalView {
        let terminalView: TerminalView = .fromNib()!
        view.addSubview(terminalView)
        //        terminalView.presenter = presenter
        terminalView.isHidden = true
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(MapViewController.hideBottomView)) // !
        swipeGesture.direction = .down
        terminalView.addGestureRecognizer(swipeGesture)
        var frame = terminalView.frame
        frame.size.width = view.frame.width
        terminalView.frame = frame
        return terminalView
    }
    
    
    private func updateInfoViewLayout(height: CGFloat) {
        var y = self.view.frame.height - height
        if let tabBarHeight = self.tabBarController?.tabBar.frame.height {
            y -= tabBarHeight
        }
        y += MapViewConstants.infoViewBottomInset
        infoView.frame.origin.y = y
    }
    
    
    private func updateTerminalViewLayout() {
        
        terminalView.layoutIfNeeded()
        let y = self.view.frame.height - terminalView.frame.height
        terminalView.frame.origin.y = y
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
    
    
    private func configureMap() {
        if #available(iOS 11.0, *) {
            mapView.register(PinAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        }
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        mapView.userLocation.title = ""
    }
    
    
    private func moveInfoView(up: Bool, completion: (()->())? = nil) { // -
        var y = self.view.frame.height
        y -= up ? self.infoView.frame.height : 0
        y += MapViewConstants.infoViewBottomInset
        if let tabBarHeight = self.tabBarController?.tabBar.frame.height {
            y -= tabBarHeight
        }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.infoView.frame.origin = CGPoint(x: 0, y: y)
        }) { (_) in
            completion?()
        }
    }
    
    
    private func moveTerminalView(up: Bool, completion: (()->())? = nil) { // -
        var y = self.view.frame.height
        y -= up ? self.terminalView.frame.height : 0
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.terminalView.frame.origin = CGPoint(x: 0, y: y)
        }) { (_) in
            completion?()
        }
    }
    
    private func moveConfirmationView(up: Bool, completion: (()->())? = nil) { // -
        var y = self.view.frame.height
        y -= up ? self.confirmationView.frame.height : 0
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.confirmationView.frame.origin = CGPoint(x: 0, y: y)
        }) { (_) in
            completion?()
        }
    }
    
    
    private func configureBars() {
        if !isAuthorized {
            createBackButton()
            createLocationButton()
            title = "Где купить карту"
            return
        }
        
        if isWashingStart {
            createBackButton()
            tabBarController?.tabBar.isHidden = true
            title = "Мойки в городе"
            return
        }
        
        createExitButton()
        createLocationButton()
    }
    
    
    @objc private func hideBottomView() {
        if isWashingStart {
            if !terminalView.isHidden {
                moveTerminalView(up: false) { [weak self] in
                    self?.terminalView.isHidden = true
                }
            }
          
            if !confirmationView.isHidden {
                moveConfirmationView(up: false) { [weak self] in
                    self?.confirmationView.isHidden = true
                }
            }
        } else {
            if !infoView.isHidden {
                moveInfoView(up: false) { [weak self] in
                    self?.infoView.isHidden = true
                }
            }
        }
        mapView.removeGestureRecognizer(tapGesture)
        deselectAnnotations()
    }
    
    private func deselectAnnotations() {
        mapView.selectedAnnotations.forEach { (annotation) in
            mapView.deselectAnnotation(annotation, animated: true)
        }
    }
    
    
     private func selectAnnotation(id: Int) {
         let annotaions = pointAnnotations.filter { (annotation) -> Bool in
             annotation.id == id
         }
         
         if let annotaion = annotaions.first {
             mapView.selectAnnotation(annotaion, animated: true)
             let lat = annotaion.coordinate.latitude - washLocationDelta / 4
             let lon = annotaion.coordinate.longitude
             select(latitude: lat, longitude: lon, locationDelta: washLocationDelta)
         }
     }
    
    private func select(annotation: CustomPointAnnotation, view: MKAnnotationView) {
        
        annotation.action?()
        view.image = UIImage(named: MapViewConstants.selectedPinImageName)
        if let label = view.viewWithTag(MapViewConstants.pinLabelTag) as? UILabel {
            label.textColor = Constants.blue
            //                label.frame.origin = CGPoint(x: MapViewConstants.selectedPinXOrigin,
            //                                             y: MapViewConstants.selectedPinYOrigin)
            let x =  (view.frame.width - label.frame.width) / 2
            let y = MapViewConstants.pinYOrigin
            label.frame.origin = CGPoint(x: x, y: y)
        }
        mapView.layoutIfNeeded()
        
    }
    
    
    private func showAnimatedSkeleton(view: UIView, color: UIColor) {
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight, duration:  MainSceneConstants.sceletonAnimationDuration) // !!!
        view.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: color), animation: animation)
    }
        
}

//MARK: - MapViewProtocol

extension MapViewController: MapViewProtocol {
    
    func showConfirmationView(address: String, startButtonAction: @escaping () -> ()) {
        moveTerminalView(up: false) { [weak self] in
            self?.terminalView.isHidden = true
        }
        confirmationView.set(address: address)
        confirmationView.startButtonPressed = startButtonAction
        confirmationView.frame.origin = CGPoint(x: 0, y: view.frame.height)
        confirmationView.layoutIfNeeded()
        confirmationView.isHidden = false
        moveConfirmationView(up: true)
    }
    
    func showMessage(text: String) {
        var attributes = EKAttributes.bottomFloat
        attributes.entryBackground = .color(color: EKColor(UIColor(hex: "007BED")!))
        attributes.displayDuration = 3
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        let width = view.frame.width - MapViewConstants.standardSpacing * 2
        let widthConstraint = EKAttributes.PositionConstraints.Edge.constant(value: width)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: Constants.messageViewHeight)
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        SwiftEntryKit.display(entry: titleLabel, using: attributes)
    }
    
    
    func select(latitude: Double, longitude: Double, locationDelta: Double?) {
        let delta = locationDelta == nil ? self.washLocationDelta : locationDelta!
        let span = MKCoordinateSpan(latitudeDelta: delta,
                                    longitudeDelta: delta)
        let coordinate = CLLocationCoordinate2D(latitude: latitude,
                                                longitude: longitude)
        let region = MKCoordinateRegion(center: coordinate,
                                        span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    override func showAlert(message: String,
                            title: String,
                            okButtonTitle: String,
                            cancelButtonTitle: String,
                            okAction: (() -> ())?,
                            cancelAction: (() -> ())?) {
        if let alertView: AlertView = .fromNib() {
            alertView.set(title: title,
                          text: message,
                          okAction: okAction,
                          cancelAction: cancelAction,
                          okButtonTitle: okButtonTitle,
                          cancelButtonTitle: cancelButtonTitle)
            let window = UIApplication.shared.keyWindow!
            alertView.frame.size = window.frame.size
            window.addSubview(alertView)
        }
    }
    
    
    func detectLocation() {
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.delegate = self
    }
    
    
    func requestDidSend() {
        view.addSubview(activityView)
    }
    
    
    func responseDidRecieve() {
        activityView.removeFromSuperview()
    }
    
    
    func configureDefaultMode(latitude: Double, longitude: Double) {
        select(latitude: latitude, longitude: longitude, locationDelta: locationDelta)
    }
    
    
    func configureSelectedWashMode() {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = nil
        createBackButton()
        title = "Мойки в городе"
    }
    
    
    func selectWash(id: Int) {
        updateInfoViewLayout(height: infoView.frame.height)
        selectAnnotation(id: id)
    }
    
    
    func startWash(id: Int) {
        updateTerminalViewLayout()
        selectAnnotation(id: id)
    }
    
 
    
    func showWashingStartInfo(address: String, terminalsCount: Int) {
        terminalView.set(address: address, terminalsCount: terminalsCount)
        terminalView.didSelectTerminal = { [weak self] (termialIndex) in
            self?.presenter.didSelectTerminal(index: termialIndex, address: address)
        }
    }
    
    
    func showWashInfo(address: String, cashback: String, sales: [StockResponse], happyTimesText: String?, isHappyTimesHidden: Bool) {
        infoView.set(address: address,
                     cashback: cashback,
                     sales: sales,
                     happyTimesText: happyTimesText,
                     isHappyTimesHidden: isHappyTimesHidden)
        infoView.hideSkeleton(transition: .crossDissolve(Constants.skeletonCrossDissolve))
    }
    
    
    func set(latitude: Double, longitude: Double, id: Int, cashbackText: String, action: (()->())?) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let pointAnnotation = configurePinAnnotation()
        let pointAnnotation = CustomPointAnnotation()
        
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
        
        if #available(iOS 12.0, *) { return nil }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        if let customPointAnnotation = annotation as? CustomPointAnnotation {
            annotationView.image = UIImage(named: MapViewConstants.pinImageName)
            let label = UILabel()
            
            label.textColor = .white
            label.text = customPointAnnotation.text
            label.font =  UIFont.systemFont(ofSize: 12, weight: .bold)
            label.tag = MapViewConstants.pinLabelTag
            label.sizeToFit()
            
            let x =  (annotationView.frame.width - label.frame.width) / 2
            let y = MapViewConstants.pinYOrigin
            label.frame.origin = CGPoint(x: x, y: y)
            
            annotationView.subviews.forEach({ $0.removeFromSuperview() })
            annotationView.addSubview(label)
            //            label.center = annotationView!.center
        }
        return annotationView
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        if #available(iOS 11.0, *),
            let annotation = view.annotation as? MKClusterAnnotation {
            hideBottomView()
            mapView.showAnnotations(annotation.memberAnnotations, animated: true)
            return
        }
        
        if let annotation = view.annotation as? CustomPointAnnotation {
            SwiftEntryKit.dismiss()
            select(annotation: annotation, view: view)
        }
    }


    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard view.annotation is CustomPointAnnotation else { return }
        
        view.image = UIImage(named: MapViewConstants.pinImageName)
        
        if let label = view.viewWithTag(MapViewConstants.pinLabelTag) as? UILabel {
            label.textColor = .white
            let x =  (view.frame.width - label.frame.width) / 2
            let y = MapViewConstants.pinYOrigin
            label.frame.origin = CGPoint(x: x, y: y)
        }
    }
    
    func configureWashingStartView() {
        
        if terminalView.isHidden {
            if !confirmationView.isHidden {
                moveConfirmationView(up: false) { [weak self] in
                    self?.confirmationView.isHidden = true
                }
            } else {
                mapView.addGestureRecognizer(tapGesture)
            }
            
            terminalView.isHidden = false
            terminalView.layoutIfNeeded()
            moveTerminalView(up: true)
        }
        //            terminalView.initViews()
                    updateTerminalViewLayout()
        //            showAnimatedSkeleton(view: terminalView, color: .clouds)
        
    }
    
    
    func configureWashInfoView() {
        if infoView.isHidden {
            infoView.isHidden = false
            infoView.layoutIfNeeded()
            mapView.addGestureRecognizer(tapGesture)
            moveInfoView(up: true)
        }
        infoView.initViews()
        updateInfoViewLayout(height: infoView.frame.height)
        showAnimatedSkeleton(view: infoView, color: .clouds)
    }
    
    
    func setError(message: String) {
        hideBottomView()
        showAlert(message: message,
                  title: "Ошибка",
                  okButtonTitle: "OK",
                  cancelButtonTitle: "",
                  okAction: nil,
                  cancelAction: nil)
    }
    
    
    func setSucceeded(message: String) {
        hideBottomView()
        showAlert(message: message,
                  title: "Успешно",
                  okButtonTitle: "OK",
                  cancelButtonTitle: "",
                  okAction: { [weak self] in
                    self?.tabBarController?.tabBar.isHidden = false
                    self?.tabBarController?.selectedIndex = 0
                    self?.navigationController?.popToRootViewController(animated: false)
        },
                  cancelAction: nil)
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
            guard let self = self else { return }
            self.hideBottomView()
        }
    }
    
}


// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let stats: [CLAuthorizationStatus] = [.authorizedAlways, .authorizedWhenInUse]
        if stats.contains(status) {
            if let coordinate = manager.location?.coordinate {
                presenter.didReceiveUserLocation(lat: coordinate.latitude,
                                                 lon: coordinate.longitude)
            }
        }
    }
    
}

