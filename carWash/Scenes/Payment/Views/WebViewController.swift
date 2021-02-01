//
//  WebViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 27.05.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    var html: String
    
    init(html: String) {
        self.html = html
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        webView.loadHTMLString(html, baseURL: nil)
    }

    override func viewDidLoad() {
        createCloseButton()
        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - NavigationBarConfigurationProtocol

extension WebViewController: NavigationBarConfigurationProtocol {
    
    func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
}
