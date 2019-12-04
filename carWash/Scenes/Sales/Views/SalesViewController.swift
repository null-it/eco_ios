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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        configureCollectionView()
    }
        
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(nibName: SalesCollectionViewCell.nibName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: SalesCollectionViewCell.nibName)
    }
}


// MARK: - SalesViewProtocol

extension SalesViewController: SalesViewProtocol {
    
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
        return 10 //
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SalesCollectionViewCell.nibName, for: indexPath) as? SalesCollectionViewCell {
            // configuration
            return cell
        }
        return UICollectionViewCell()
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension SalesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 2 * SalesViewConstants.standartSpacing
        let height = SalesViewConstants.saleCellHeight
        let size = CGSize(width: width, height: height)
        return size
    }
    
}

