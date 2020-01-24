//
//  WashingInfoView.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class WashingInfoView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var salesLabel: UILabel!
    @IBOutlet weak var salesTitleLabel: UILabel!
    @IBOutlet weak var happyTimesLabel: UILabel!
    @IBOutlet weak var salesView: UIView!
    @IBOutlet weak var happyTimesView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    
    // MARK: - Properties
    
    var presenter: MapPresenterProtocol!
    var sales: [StockResponse] = []
    
    var heightChanged: ((CGFloat) -> ())?
    
    var isSalesViewHidden = false {
        didSet {
           updateSalesViewHiddenness()
        }
    }
    
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        configureCollectionView()
        happyTimesLabel.sizeToFit() // !!!!!!
    }
   
    
    // MARK: - Private
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(nibName: WashingInfoSaleCell.nibName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: WashingInfoSaleCell.nibName)
    }
    
    private func updateSalesViewHiddenness() {
        salesView.isHidden = isSalesViewHidden
        print("isSalesViewHidden", isSalesViewHidden)
        salesView.layoutIfNeeded()
        if #available(iOS 11.0, *) {
            layoutIfNeeded()
        }
        frame.size.height = stackView.frame.height
        heightChanged?(frame.height)
    }
    
    func set(address: String, cashback: String, sales: [StockResponse]) {
        addressLabel.text = address
        salesLabel.text = cashback
        self.sales = sales
        collectionView.reloadData()
//        if !sales.isEmpty {
//            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
//        }
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
        presenter.presentSaleInfoView(row: indexPath.row)
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension WashingInfoView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.frame.width - MapViewConstants.standardSpacing * 2
        if sales.count > 1 {
            width -= MapViewConstants.washingInfoSaleSmallCellDifference
        }
        let height: CGFloat = MapViewConstants.washingInfoSaleCellHeight 
        let size = CGSize(width: width, height: height)
        return size
    }
    
}
