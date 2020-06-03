//
//  WashingStartViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 06.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit

class WashingStartViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: WashingStartPresenterProtocol!
    var configurator: WashingStartConfiguratorProtocol!
    
    lazy var mapTapGesture: UITapGestureRecognizer = {
        configureMapTapGestureRecognizer()
    }()

    lazy var qrTapGesture: UITapGestureRecognizer = {
        configureQRTapGestureRecognizer()
    }()

    
    // MARK: - Outlets

    @IBOutlet weak var mapInfoButton: UIButton!
    @IBOutlet weak var qrInfoButton: UIButton!
    
    @IBOutlet weak var qrInfoView: UIView!
    @IBOutlet weak var mapInfoView: UIView!
    
    @IBOutlet weak var mapInfoLabel: UILabel!
    @IBOutlet weak var qrInfoLabel: UILabel!
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var qrView: UIView!
    
    
    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        mapInfoLabel.sizeToFit()
        qrInfoLabel.sizeToFit()
//        mapInfoLabel.layoutIfNeeded()
//        qrInfoLabel.layoutIfNeeded()
//        qrInfoView.layoutIfNeeded()
//        mapInfoView.layoutIfNeeded()
//        view.layoutIfNeeded()
    }

    override func viewDidLoad() {
        mapView.addGestureRecognizer(mapTapGesture)
        qrView.addGestureRecognizer(qrTapGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        setShadows()
    }
    
    override func viewDidLayoutSubviews() {
        updateShadows()
    }
    
    // MARK: - Actions
    
    @IBAction func mapInfoButtonPressed(_ sender: Any) {
//        UIView.animate(withDuration: 0.5,
//                       animations: {  [weak self] in
//                        guard let self = self else { return }
                        self.mapInfoView.isHidden = !self.mapInfoView.isHidden
                        let image = self.mapInfoView.isHidden
                            ? WashingStartConstants.openButtonImage
                            : WashingStartConstants.closeButtonImage
                        self.mapInfoButton.setImage(image, for: .normal)
//        })
    }
    
    @IBAction func WashingStartInfoButtonPressed(_ sender: Any) {
//        UIView.animate(withDuration: 0.5,
//                       animations: { [weak self] in
//                        guard let self = self else { return }
                        self.qrInfoView.isHidden = !self.qrInfoView.isHidden
                        let image = self.qrInfoView.isHidden
                            ? WashingStartConstants.openButtonImage
                            : WashingStartConstants.closeButtonImage
                        self.qrInfoButton.setImage(image, for: .normal)
//        })
    }
    
    
    // MARK: - Private
    
    private func configureQRTapGestureRecognizer() -> UITapGestureRecognizer {
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(WashingStartViewController.qrViewTapped))
        tapGesture.delegate = self
        return tapGesture
    }
    
    @objc private func qrViewTapped() {
        presenter.qrViewTapped()
    }
    
    private func configureMapTapGestureRecognizer() -> UITapGestureRecognizer {
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(WashingStartViewController.mapViewTapped))
        tapGesture.delegate = self
        return tapGesture
    }
    
    @objc private func mapViewTapped() {
        presenter.mapViewTapped()
    }
    

    private func setShadows() {
        setShadow(view: mapView)
        setShadow(view: qrView)
    }
    
    private func setShadow(view: UIView) {
        view.layer.masksToBounds = false
        view.layer.cornerRadius = QRConstants.cornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: QRConstants.cornerRadius).cgPath
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
    }
    
    private func updateShadows() {
        mapView.layoutIfNeeded()
        qrView.layoutIfNeeded()
        updateShadow(view: mapView)
        updateShadow(view: qrView)
    }
    
    private func updateShadow(view: UIView) {
        view.layoutIfNeeded()
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: QRConstants.cornerRadius).cgPath
    }
    
}


// MARK: - WashingStartViewProtocol

extension WashingStartViewController: WashingStartViewProtocol {
    
}



// MARK: - UIGestureRecognizerDelegate

extension WashingStartViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        guard let touchView = touch.view,
            let gestureRecognizerView = gestureRecognizer.view else { return true }
        return touchView.isDescendant(of: gestureRecognizerView)
    }
    
}
