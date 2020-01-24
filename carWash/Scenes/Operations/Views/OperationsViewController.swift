//
//  OperationsFilterViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit


class OperationsViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: OperationsPresenterProtocol!
    var configurator: OperationsConfiguratorProtocol!

    private let refreshControl = UIRefreshControl()

    lazy var activityView: UIView = {
       configureActivityView()
    }()

    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        configureTableView()
        configureNavigationBar()
        presenter.viewDidLoad()
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
    
    
    private func configureActivityView() -> UIView {
        let activityView = UIView()
        let currentWindow = UIApplication.shared.keyWindow!
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.widthAnchor.constraint(equalToConstant: currentWindow.frame.width).isActive = true
        activityView.heightAnchor.constraint(equalToConstant: currentWindow.frame.height).isActive = true
        
        activityView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        let activityIndicator = UIActivityIndicatorView()
        
        activityView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: activityView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: activityView.centerYAnchor).isActive = true
        
        activityIndicator.startAnimating()
        activityIndicator.color = .black
        return activityView
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
        view.addSubview(activityView)
        tableView.isHidden = true
    }
    
    
    func responseDidRecieve() {
        activityView.removeFromSuperview()
        tableView.isHidden = false
    }
    
    func dataRefreshed() {
        refreshControl.endRefreshing()
    }
    
}

//MARK: - UITableViewDataSource

extension OperationsViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter.operationsCount
        configureTableView(isEmpty: count == 0)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewActionCell", for: indexPath)
            as? MainViewActionCell {
            if indexPath.row < presenter.operationsCount,
                let info = presenter.operationsInfo[indexPath.row] {
                let image = UIImage(named: info.imageName)
                cell.configure(image: image,
                               title: info.title,
                               sum: info.sum,
                               time: info.time)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
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


