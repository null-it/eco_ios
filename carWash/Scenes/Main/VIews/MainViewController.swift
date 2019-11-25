//
//  MainViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 18.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    var presenter: MainPresenterProtocol!
    var configurator: MainConfiguratorProtocol!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var helloView: UIView!
    @IBOutlet weak var cashBackView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        configureTableView()
        scrollView.delegate = self
        createTopViewShadow()
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let object = object as? UITableView {
            if object == tableView {
                let height = tableView.contentSize.height
                tableViewHeight.constant = height
            }
        }
    }
    
    
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    
    // MARK: - Views configuration
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "MainViewActionCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "MainViewActionCell")
        tableView.addObserver(self, forKeyPath: "contentSize", options: .old, context: nil)
    }
    
    
    private func createTopViewShadow() {
        topView.layer.masksToBounds = false
        topView.layer.cornerRadius = MainSceneConstants.cornerRadius
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowPath = UIBezierPath(roundedRect: topView.bounds, cornerRadius: MainSceneConstants.cornerRadius).cgPath
        topView.layer.shadowOffset = CGSize(width: MainSceneConstants.shadowOffsetX,
                                            height: MainSceneConstants.shadowOffsetY)
        topView.layer.shadowOpacity = MainSceneConstants.shadowOpacity
        topView.layer.shadowRadius = MainSceneConstants.shadowRadius
        if #available(iOS 11.0, *) {
            topView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    
    
    private func set(view: UIView, hidden: Bool) {
        var difference = view.frame.height
        if hidden {
            difference.negate()
        }
        let newHeight = topView.frame.height + difference
        var newBounds = self.topView.bounds
        newBounds.size.height = newHeight
        
        UIView.animate(withDuration: MainSceneConstants.animationDuration,
                       animations: { [weak self] in
                        view.isHidden = hidden
                        view.alpha = hidden ? 0 : 1
                        if hidden {
                            self?.updateShadow(bounds: newBounds,
                                               cornerRadius: MainSceneConstants.cornerRadius)
                        }
        }) { [weak self] (_) in
            if !hidden {
                self?.updateShadow(bounds: newBounds,
                                   cornerRadius: MainSceneConstants.cornerRadius)
            }
        }
    }
    
    private func updateShadow(bounds: CGRect, cornerRadius: CGFloat) {
        topView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
    
}


//MARK: - MainViewProtocol

extension MainViewController: MainViewProtocol {
    
       
}


//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {

    
}


//MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewActionCell", for: indexPath)
            as? MainViewActionCell {
            // ...
            return cell
        }
        return UITableViewCell()
    }
           
}


//MARK: - UIScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let hideHelloView = scrollView.contentOffset.y >= helloView.frame.height
        let hideCashBackView =  scrollView.contentOffset.y >= cashBackView.frame.height + helloView.frame.height
        
        if hideHelloView && !helloView.isHidden {
            set(view: helloView, hidden: true)
        } else if !hideHelloView && helloView.isHidden {
            set(view: helloView, hidden: false)
        }
        
        if hideCashBackView && !cashBackView.isHidden {
            set(view: cashBackView, hidden: true)
        } else if !hideCashBackView && cashBackView.isHidden {
            set(view: cashBackView, hidden: false)
        }
    }
    
}
