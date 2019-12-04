//
//  WashingInfoView.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class WashingInfoView: UIView {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: MapPresenterProtocol!

    override func awakeFromNib() {
        configureCollectionView()
    }
   
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(nibName: WashingInfoSaleCell.nibName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: WashingInfoSaleCell.nibName)
    }
    
}


// MARK: - UICollectionViewDataSource

extension WashingInfoView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WashingInfoSaleCell.nibName, for: indexPath) as? WashingInfoSaleCell {
            // !..
            return cell
        }
        return UICollectionViewCell()
    }
    
}


// MARK: - UICollectionViewDelegate

extension WashingInfoView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.presentSaleInfoView()
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension WashingInfoView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 16 * 2 - 30 // !
        let height: CGFloat = 122 // !
        let size = CGSize(width: width, height: height)
        return size
    }
    
}
