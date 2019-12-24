//
//  SalesViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit


class SalesViewController: UIViewController {
    
    var presenter: SalesPresenterProtocol!
    var configurator: SalesConfiguratorProtocol!
    var sales: [SaleResponseData] = []
    let emptyCollectionBackgroundView: EmptySalesView = .fromNib()!

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        configureCollectionView()
        createExitButton()
        createLocationButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewDidLoad()
    }
        
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(nibName: SalesCollectionViewCell.nibName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: SalesCollectionViewCell.nibName)
    }
    
    private func configureCollectionView(isEmpty: Bool) {
        if isEmpty {
            collectionView.backgroundView = emptyCollectionBackgroundView
        } else {
            collectionView.backgroundView = nil
        }
    }
    
}


// MARK: - SalesViewProtocol

extension SalesViewController: SalesViewProtocol {
 
    func updateSales(sales: [SaleResponseData]) {
        self.sales = sales
        collectionView.reloadData()
    }
    
}


// MARK: - UICollectionViewDelegate

extension SalesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.presentSaleInfoView()
    }
    
}


// MARK: - UICollectionViewDataSource

extension SalesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = sales.count
        configureCollectionView(isEmpty: count == 0)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SalesCollectionViewCell.nibName, for: indexPath) as? SalesCollectionViewCell {
            cell.configure(data: sales[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension SalesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 2 * SalesViewConstants.standartSpacing
        let height = width * SalesViewConstants.saleCellAspectRatio
        let size = CGSize(width: width, height: height)
        return size
    }
    
}


// MARK: - NavigationBarConfigurationProtocol

extension SalesViewController: NavigationBarConfigurationProtocol {
    
    @objc func exitButtonPressed() {
        presenter.logout()
    }
    
    @objc func locationButtonPressed() {
        presenter.selectCity()
    }
}

