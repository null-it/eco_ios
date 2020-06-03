//
//  SalesViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import SkeletonView


class SalesViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: SalesPresenterProtocol!
    var configurator: SalesConfiguratorProtocol!
    var sales: [SaleResponse?] = []
    var images: [UIImage?] = []
    let emptyCollectionBackgroundView: EmptySalesView = .fromNib()!
    var refreshControl = UIRefreshControl()
    lazy var isSE: Bool = {
        let modelName = UIDevice.modelName
        return Constants.SE.contains(modelName)
    }()
    
    // MARK: - Outlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        configureCollectionView()
        createExitButton()
        createLocationButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewDidLoad()
        configureRefreshControl()
        collectionView.setContentOffset(.zero, animated: true)
    }
    
    
    // MARK: - Private
        
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(nibName: SalesCollectionViewCell.nibName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: SalesCollectionViewCell.nibName)
        collectionView.prefetchDataSource = self
    }
    
    
    private func configureRefreshControl() {
         refreshControl = UIRefreshControl()
         refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
         collectionView.refreshControl = refreshControl
         refreshControl.setValue(Constants.refreshControlValue, forKey: "_snappingHeight")
    }
    
    
    @objc private func refreshData(_ sender: Any) {
        presenter.refreshData()
    }
    
    
    private func configureCollectionView(isEmpty: Bool) {
        if isEmpty {
            collectionView.backgroundView = emptyCollectionBackgroundView
        } else {
            collectionView.backgroundView = nil
        }
    }
    
    private func showAnimatedSkeleton(view: UIView, color: UIColor) {
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight, duration:  MainSceneConstants.sceletonAnimationDuration) // !!!
        view.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: color), animation: animation)
    }
    
}


// MARK: - SalesViewProtocol

extension SalesViewController: SalesViewProtocol {
    
    func dataRefreshingError() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.collectionView.setContentOffset(.zero, animated: true)
        }
    }

    func refreshDidEnd() {
        refreshControl.endRefreshing()
    }
    
    func presentSaleInfoView(id: Int) {
        presenter.presentSaleInfoView(id: id)
    }
    
    func requestDidSend() {
        showAnimatedSkeleton(view: view, color: .clouds)
    }
    
    func responseDidRecieve() {
        view.hideSkeleton(transition: .crossDissolve(Constants.skeletonCrossDissolve))
    }
    
    
    func reload(rows: [Int], sales: [SaleResponse?]) {
        self.sales = sales
        let indexPaths = rows.map { (row) -> IndexPath in
            IndexPath(row: row, section: 0)
        }
        UIView.performWithoutAnimation { [weak self] in
            self?.collectionView.reloadItems(at: indexPaths)
        }
    }
    
    
    func reloadData(sales: [SaleResponse?]) {
        self.sales = sales
        images = Array(repeating: nil, count: sales.count)
        collectionView.reloadData()
        collectionView.isHidden = false
    }
    
}


// MARK: - UICollectionViewDelegate

extension SalesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.presentSaleInfoView(row: indexPath.row)
    }
    
}


// MARK: - UICollectionViewDataSource

extension SalesViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = sales.count
        configureCollectionView(isEmpty: count == 0)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { // !
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SalesCollectionViewCell.nibName, for: indexPath) as? SalesCollectionViewCell {
            if let data = sales[indexPath.row] {
                cell.hideSkeleton()
                cell.tag = data.id
                let image = images[indexPath.row]
                cell.setImage(image)
                cell.configure(title: data.title, date: "\(data.startedAt!) - \(data.finishedAt!)") // !
                if image == nil {
                    if !data.logo.isEmpty {
                        let url = URL(string: data.logo)
                        DispatchQueue.global().async {
                            if let imageData = try? Data(contentsOf: url!) {
                                DispatchQueue.main.async { [weak self] in
                                    if cell.tag == data.id,
                                        let image = UIImage(data: imageData),
                                        let self = self,
                                        self.images.count > indexPath.row {
                                        self.images[indexPath.row] = image
                                        cell.setImage(image)
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
//                cell.setImage(nil)
//                cell.configure(title: "", date: "")
                showAnimatedSkeleton(view: cell, color: .clouds)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
}


extension SalesViewController: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        SalesCollectionViewCell.nibName
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension SalesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat!
        let height: CGFloat!
        
        if isSE {
            width = SalesViewConstants.saleSECellWidth
            height = SalesViewConstants.saleSECellHeight
        } else {
            width = view.frame.width - 2 * SalesViewConstants.standartSpacing
            height = width * SalesViewConstants.saleCellAspectRatio
        }
        
        let size = CGSize(width: width, height: height)
        return size
    }
    
}


// MARK: - UICollectionViewDataSourcePrefetching

extension SalesViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            presenter.loadPage(for: indexPath.row)
        }
        
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

