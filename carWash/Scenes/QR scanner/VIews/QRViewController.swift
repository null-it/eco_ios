//
//  QRView.swift
//  carWash
//
//  Created by Juliett Kuroyan on 03.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import AVFoundation
import UIKit

class QRViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: QRPresenterProtocol!
    var configurator: QRConfiguratorProtocol!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var cornersView: CornersRect?
    var workItem: DispatchWorkItem?
    var timer: Timer?
    lazy var infoView: AlertView = .fromNib()!
    lazy var cameraAccessView: CameraAccessView = .fromNib()!
    
    // !
    var isAlreadyDetected = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        title = QRConstants.title
        configureQRScanner()
        configureBottomView()
//        createInfoButton()
        createBackButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let session = captureSession,
            !session.isRunning {
            captureSession.startRunning()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let session = captureSession,
            session.isRunning {
            captureSession.stopRunning()
        }
    }
    
    
    //    override var prefersStatusBarHidden: Bool {
    //        return true
    //    }
    //
    //
    //    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    //        return .portrait
    //    }
    
    
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
    
    
    // MARK: - Private
    
    private func configureQRScanner() {
        
        if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
            AVCaptureDevice.requestAccess(for: .video,
                                          completionHandler: { [weak self] (granted) in
                                            if !granted {
                                                DispatchQueue.main.async {
                                                    self?.cameraIsNotAvailable()
                                                    return
                                                }
                                            }
            })
        }
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            cameraIsNotAvailable()
            return
        }
        
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
            
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let height = view.frame.size.height - navBarHeight - statusBarHeight //  - QRConstants.qrInset - bottomView.frame.height
        var rect = view.frame
        rect.size.height = height
        rect.origin.y = navBarHeight + QRConstants.qrInset
        metadataOutput.rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: rect)
    }
    
    
    private func cameraIsNotAvailable() {
        cameraAccessView.frame = view.frame
        view.addSubview(cameraAccessView)
        bottomView.isHidden = true
    }
    
    
    private func configureBottomView() {
        bottomView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: QRConstants.bottomViewCornerRadius)
        view.bringSubviewToFront(bottomView)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(QRViewController.hideBottomView))  // !
        swipeGesture.direction = .down
        bottomView.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func hideBottomView() {
        var y = view.frame.height
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.bottomViewBottomConstraint.constant = -y
            self?.view.layoutIfNeeded()
        })  { [weak self] _ in
            self?.bottomView.isHidden = true
        }
    }
    
    private func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    
    private func configureCornersView(rect: CGRect) {
        var convertedRect = view.layer.convert(rect, from: previewLayer)
        let inset: CGFloat = QRConstants.qrInset
        convertedRect.origin.x -= inset
        convertedRect.origin.y -= inset
        convertedRect.size.width += 2 * inset
        convertedRect.size.height += 2 * inset
        
        if cornersView == nil {
            cornersView = CornersRect(frame: convertedRect)
            cornersView!.backgroundColor = .clear
            cornersView!.shadowColor = UIColor.black.withAlphaComponent(0.48)
            cornersView!.shadowRadius = 4
            cornersView!.shadowOffset = CGSize(width: 0, height: 0)
            cornersView!.shadowOpacity = 1
            view.addSubview(cornersView!)
            view.bringSubviewToFront(bottomView)
        } else {
            if cornersView!.isHidden || timer == nil {
                timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { [weak self] (_) in
                    self?.timer = nil
                })
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.cornersView!.frame = convertedRect
                }
            }
            UIView.animate(withDuration: 1) { [weak self] in
                self?.cornersView!.isHidden = false
            }
        }
    }
    
}


// MARK: - QRViewProtocol

extension QRViewController: QRViewProtocol {
    
    func setError(message: String) {
        hideBottomView()
        showAlert(message: message,
                  title: "Ошибка",
                  okButtonTitle: "OK",
                  cancelButtonTitle: "",
                  okAction: { [weak self] in
                    self?.isAlreadyDetected = false
        },
                  cancelAction: nil)
    }
    
    
    func setSucceeded(message: String) {
        hideBottomView()
        cornersView?.removeFromSuperview()
        cornersView = nil
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


// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension QRViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        
        if metadataObjects.isEmpty {
            cornersView?.removeFromSuperview()
            cornersView = nil
        }
        
        guard !isAlreadyDetected else { return }
        
        //        captureSession.stopRunning()
        
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            
            if #available(iOS 11.0, *) {
                let rect = previewLayer.layerRectConverted(fromMetadataOutputRect: metadataObject.bounds)
                configureCornersView(rect: rect)
            }
            
            guard let stringValue = readableObject.stringValue else { return }
                        
            isAlreadyDetected = true

            showAlert(message: "Начать мойку?",
                      title: "Подтверждение",
                      okButtonTitle: "Да",
                      cancelButtonTitle: "Нет",
                      okAction: { [weak self] in
                        self?.presenter.found(code: stringValue)
            }) { [weak self] in
                self?.isAlreadyDetected = false
            }
        }
    }
    
}


// MARK: - NavigationBarConfigurationProtocol

extension QRViewController: NavigationBarConfigurationProtocol {
    
    func infoButtonPressed() {
        infoView.set(title: "Условия",
                     text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                     okAction: nil,
                     cancelAction: nil,
                     okButtonTitle: "OK",
                     cancelButtonTitle: "")
        
        let window = UIApplication.shared.keyWindow!
        infoView.frame.size = window.frame.size
        window.addSubview(infoView)
    }
    
    func backButtonPressed() {
        presenter.popView()
    }
    
}
