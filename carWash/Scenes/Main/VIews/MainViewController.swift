//
//  MainViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 18.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {

    // MARK: - Properties
    
    var presenter: MainPresenterProtocol!
    var configurator: MainConfiguratorProtocol!
    var cashbackTypes: [CashbackTypeInfo] = []
    
    var cashBackViewHeight: CGFloat!
    var helloViewHeight: CGFloat!

    // MARK: - Outlets

    @IBOutlet weak var cashbackCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var helloView: UIView!
    @IBOutlet weak var cashBackView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        configureTableView()
        configurCashbackCollectionView()
        scrollView.delegate = self
        createTopViewShadow()
        presenter.viewDidLoad()
        createExitButton()
        
        cashBackViewHeight = cashBackView.frame.height
        helloViewHeight = helloView.frame.height
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
    
    
    // MARK: - Private
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "MainViewActionCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "MainViewActionCell")
        tableView.addObserver(self, forKeyPath: "contentSize", options: .old, context: nil)
    }
    
    
    private func createTopViewShadow() {
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowPath = UIBezierPath(roundedRect: topView.bounds, cornerRadius: MainSceneConstants.cornerRadius).cgPath
        topView.layer.shadowOffset = CGSize(width: MainSceneConstants.shadowOffsetX,
                                            height: MainSceneConstants.shadowOffsetY)
        topView.layer.shadowOpacity = MainSceneConstants.shadowOpacity
        topView.layer.shadowRadius = MainSceneConstants.shadowRadius
        topView.layer.cornerRadius = MainSceneConstants.cornerRadius
        if #available(iOS 11.0, *) {
            topView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
//           masked corners for ios 10
        }
    }
    
    
    private func set(view: UIView, hidden: Bool) {

//        var difference = view.frame.height
        var difference = view == helloView
            ? helloViewHeight!
            : cashBackViewHeight! // ! ios 10
        
        if hidden {
            // difference.negate()
            difference = -difference
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
    
    
    private func configurCashbackCollectionView() {
        cashbackCollectionView.delegate = self
        cashbackCollectionView.dataSource = self
        let cellNib = UINib(nibName: CashbackCollectionViewCell.nibName, bundle: nil)
        cashbackCollectionView.register(cellNib, forCellWithReuseIdentifier: CashbackCollectionViewCell.nibName)
    }
    
    
    // MARK: - Actions
    
    @IBAction func paymentButtonPressed(_ sender: Any) {
        presenter.presentPaymentView()
    }
    
    
}


//MARK: - MainViewProtocol

extension MainViewController: MainViewProtocol {
    
    func updateFor(info: [CashbackTypeInfo]) {
        cashbackTypes = info
        cashbackCollectionView.reloadData()
    }
    
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
        guard let helloViewHeight = helloViewHeight,
            let cashBackViewHeight = cashBackViewHeight else {
                return
        }
        
        let hideHelloView = scrollView.contentOffset.y >= helloViewHeight
        let hideCashBackView =  scrollView.contentOffset.y >= cashBackViewHeight + helloViewHeight
        
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


// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = MainSceneConstants.cashbackCellHeight
        let spacesCount = cashbackTypes.count - 1
        let spcesWidth = CGFloat(MainSceneConstants.cashbackCellsSpacing * spacesCount)
        let width = (collectionView.frame.width - spcesWidth) / CGFloat(cashbackTypes.count)
        let size = CGSize(width: width, height: height)
        return size
    }
    
}


// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cashbackTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CashbackCollectionViewCell.nibName, for: indexPath) as? CashbackCollectionViewCell {
            let info = cashbackTypes[indexPath.row]
            cell.configure(info: info)
            return cell
        }
        return UICollectionViewCell()
    }
    
}


// MARK: - NavigationBarConfigurationProtocol

extension MainViewController: NavigationBarConfigurationProtocol {

    @objc func exitButtonPressed() {
        presenter.logout()
    }

}
