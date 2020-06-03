//
//  WashingInfoView.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import SkeletonView

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
    @IBOutlet weak var addressView: UIView!
    
    @IBOutlet weak var happyTimesViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var happyTimesViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var happyTimesViewBottomConstraint: NSLayoutConstraint!
    
    
    // MARK: - Properties
    
    var presenter: MapPresenterProtocol!
    var sales: [StockResponse] = []
    var heightChanged: ((CGFloat) -> ())?

    var isSalesViewHidden = false {
        didSet {
           updateSalesViewHiddenness()
        }
    }
    
    var isHappyTimesViewHidden = false {
        didSet {
           updateHappyTimesViewHiddenness()
        }
    }
    
    lazy var constraintsSE = [
        happyTimesViewTrailingConstraint,
        addressViewTrailingConstraint,
        happyTimesViewLeadingConstraint,
        addressViewLeadingConstraint,
        topConstraint,
        happyTimesViewBottomConstraint
    ]
    
    lazy var isSE: Bool = {
        let modelName = UIDevice.modelName
        return Constants.SE.contains(modelName)
    }()
    
    lazy var happyHoursInfoView: AlertView = .fromNib()!
    
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        configureCollectionView()
        clipsToBounds = false
    }
   
    
    // MARK: - Private
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(nibName: WashingInfoSaleCell.nibName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: WashingInfoSaleCell.nibName)
    }
    
    private func updateSalesViewHiddenness() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self = self else { return }
            self.salesView.isHidden = self.isSalesViewHidden
        }
        if #available(iOS 11.0, *) {
            layoutIfNeeded()
        }
        frame.size.height = stackView.frame.height + MapViewConstants.infoViewBottomInset
        heightChanged?(frame.height)
    }
    
    private func updateHappyTimesViewHiddenness() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self = self else { return }
            self.happyTimesView.isHidden = self.isHappyTimesViewHidden
        }
        if #available(iOS 11.0, *) {
            layoutIfNeeded()
        }
        frame.size.height = stackView.frame.height + MapViewConstants.infoViewBottomInset
        heightChanged?(frame.height)
    }
    
    
    // MARK: - Public
    
    func set(address: String, cashback: String, sales: [StockResponse], happyTimesText: String?, isHappyTimesHidden: Bool) {
        addressLabel.text = address
        salesLabel.text = cashback
        happyTimesLabel.text = happyTimesText
        isHappyTimesViewHidden = isHappyTimesHidden
        self.sales = sales
        collectionView.reloadData()
//        if !sales.isEmpty {
//            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
//        }
    }
    
    func initViews() {
        happyTimesLabel.text = ""
        isHappyTimesViewHidden = false
        isSalesViewHidden = false
    }
    
    
    // MARK: - Actions
    
    @IBAction func happyHoursInfoView(_ sender: Any) {
        happyHoursInfoView.set(title: "Счастливые часы",
                     text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                     okAction: nil,
                     cancelAction: nil,
                     okButtonTitle: "OK",
                     cancelButtonTitle: "")
        let window = UIApplication.shared.keyWindow!
        happyHoursInfoView.frame.size = window.frame.size
        window.addSubview(happyHoursInfoView)
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


// MARK: - SkeletonCollectionViewDataSource

extension WashingInfoView: SkeletonCollectionViewDataSource {
   
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        WashingInfoSaleCell.nibName
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
