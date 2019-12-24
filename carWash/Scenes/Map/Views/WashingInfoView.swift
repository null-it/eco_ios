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
    @IBOutlet weak var salesLabel: UILabel!
    @IBOutlet weak var salesTitleLabel: UILabel!
    
    var presenter: MapPresenterProtocol!
    var sales: [StockResponse] = []
    var isSalesViewHidden = false {
        didSet {
            collectionView.isHidden = isSalesViewHidden
            salesLabel.isHidden = isSalesViewHidden
            var size = frame.size
            size.height = isSalesViewHidden ? MapViewConstants.smallInfoViewHeight : MapViewConstants.largeInfoViewHeight
            frame.size = size
            let screenSize = UIScreen.main.bounds
            frame.origin.y = screenSize.height - frame.height
            salesTitleLabel.isHidden = isSalesViewHidden
        }
    }

    override func awakeFromNib() {
        configureCollectionView()
    }
   
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(nibName: WashingInfoSaleCell.nibName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: WashingInfoSaleCell.nibName)
    }
    
    func set(address: String, cashback: String, sales: [StockResponse]) {
        addressLabel.text = address
        salesLabel.text = cashback
        self.sales = sales
        collectionView.reloadData()
    }
    
}


// MARK: - UICollectionViewDataSource

extension WashingInfoView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = sales.count
        isSalesViewHidden = count == 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WashingInfoSaleCell.nibName, for: indexPath) as? WashingInfoSaleCell {
            let sale = sales[indexPath.row]
            cell.configure(title: sale.title, date: sale.finished_at) // ! date
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
