//
//  OperationsFilterViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit
import SkeletonView


class OperationsViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: OperationsPresenterProtocol!
    var configurator: OperationsConfiguratorProtocol!

    private let refreshControl = UIRefreshControl()
    
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        configureTableView()
        configureNavigationBar()
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        view.layoutSkeletonIfNeeded()
    }
    
    
    // MARK: - Private
    
    private func configureNavigationBar() {
        createBackButton()
        createFilterButton()
        title = "Все операции"
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        let cellNib = UINib(nibName: MainViewActionCell.nibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: MainViewActionCell.nibName)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        //        refreshControl.addTarget(self, action: #selector(refreshOperationsData(_:)), for: .valueChanged)
        //        tableView.refreshControl = refreshControl
        //        refreshControl.setValue(30, forKey: "_snappingHeight")
    }
    
    
    private func configureTableView(isEmpty: Bool) {
        if isEmpty {
            let backgroundView: EmptyTransactionsView = .fromNib()!
            tableView.backgroundView = backgroundView
        } else {
            tableView.backgroundView = nil
        }
    }
    
    
    @objc private func refreshData(_ sender: Any) {
        presenter.refreshData()
    }
    
}


// MARK: - OperationsViewProtocol

extension OperationsViewController: OperationsViewProtocol {
    
    func reload(rows: [Int]) {
        let indexPaths = rows.map { (row) -> IndexPath in
            IndexPath(row: row, section: 0)
        }
        UIView.performWithoutAnimation { [weak self] in
            self?.tableView.reloadRows(at: indexPaths, with: .none)
        }
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    
    func requestDidSend() {
        showAnimatedSkeleton(view: self.view, color: .clouds)
    }
    
    private func showAnimatedSkeleton(view: UIView, color: UIColor) {
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight, duration:  MainSceneConstants.sceletonAnimationDuration) // !!!
        view.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: color),
                                          animation: animation)
    }
    
    
    func responseDidRecieve(completion: (() -> ())?) {
        view.hideSkeleton(transition: .crossDissolve(Constants.skeletonCrossDissolve))
        completion?()
    }
    
    func dataRefreshed() {
        refreshControl.endRefreshing()
    }
    
}

//MARK: - UITableViewDataSource

extension OperationsViewController {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter.operationsCount
        configureTableView(isEmpty: count == 0)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewActionCell", for: indexPath)
            as? MainViewActionCell,
            indexPath.row < presenter.operationsCount {
                if let info = presenter.operationsInfo[indexPath.row] {
                    cell.hideSkeleton()
                    let image = UIImage(named: info.imageName)
                    cell.configure(image: image,
                                   title: info.title,
                                   sum: info.sum,
                                   time: info.time)
                } else {
                    showAnimatedSkeleton(view: cell, color: .clouds)
                }
                
                return cell
            }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
}


//MARK: - SkeletonTableViewDataSource

extension OperationsViewController: SkeletonTableViewDataSource {
        
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        15
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        MainViewActionCell.nibName
    }
    
}


// MARK: - UITableViewDataSourcePrefetching

extension OperationsViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            presenter.loadPage(for: indexPath.row)
        }
    }

}


// MARK: - NavigationBarConfigurationProtocol

extension OperationsViewController: NavigationBarConfigurationProtocol {

    func backButtonPressed() {
        presenter.popView()
    }

    func filterButtonPressed() {
        presenter.filterButtonPressed()
    }
}


