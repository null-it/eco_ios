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
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var qrView: UIView!
    
    
    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
//        mapInfoLabel.sizeToFit()
//        qrInfoLabel.sizeToFit()
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
    
    // MARK: - Actions
    
    @IBAction func typeTerminalPressed(_ sender: Any) {
        mapViewTapped()
    }
    
    @IBAction func scanQRPressed(_ sender: Any) {
        qrViewTapped()
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
      let alertController = UIAlertController(title: "Внимание", message: "Укажите номер терминала", preferredStyle: .alert)
      alertController.addTextField { (textField) in
        textField.placeholder = "номер терминала"
        textField.keyboardType = .numberPad
      }
      let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
      let submitAction = UIAlertAction(title: "Ок", style: .default) { [unowned alertController] action in
        let typedNumber = alertController.textFields![0].text
        self.presenter.terminalSelected(typedNumber)
        action.isEnabled = false
      }
      alertController.addAction(cancelAction)
      alertController.addAction(submitAction)
      present(alertController, animated: true, completion: nil)
//        presenter.mapViewTapped()
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
  
  func setSucceeded(message: String) {
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
  
  func setError(message: String) {
    showAlert(message: message,
              title: "Ошибка",
              okButtonTitle: "OK",
              cancelButtonTitle: "",
              okAction: nil,
              cancelAction: nil)
  }
  
    
}



// MARK: - UIGestureRecognizerDelegate

extension WashingStartViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        guard let touchView = touch.view,
            let gestureRecognizerView = gestureRecognizer.view else { return true }
        return touchView.isDescendant(of: gestureRecognizerView)
    }
    
}
