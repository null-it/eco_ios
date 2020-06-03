//
//  CitiesViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 13.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import SkeletonView


class CitiesViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: CitiesPresenterProtocol!
    var configurator: CitiesConfiguratorProtocol!
    var cities: [String] = []
    var currentCity: String = ""
    var citiesSectionsTitles: [String] = [] // !
        
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        createBackButton()
        configureTableView()
        presenter.viewDidLoad()
        title = CitiesConstants.title
    }
    
    
    // MARK: - Private
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: CitiesTableViewCell.nibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CitiesTableViewCell.nibName)
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
    
    private func showAnimatedSkeleton(view: UIView, color: UIColor) {
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight, duration:  MainSceneConstants.sceletonAnimationDuration) // !!!
        view.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: color), animation: animation)
    }
    
}


// MARK: - CitiesViewProtocol

extension CitiesViewController: CitiesViewProtocol {
    
    func update(currentCity: String,
                cities: [String],
                titles: [String]) {
        self.currentCity = currentCity
        self.cities = cities
        self.citiesSectionsTitles = titles
        view.hideSkeleton(transition: .crossDissolve(Constants.skeletonCrossDissolve))
        tableView.reloadData()
    }
    
    func requestDidSend() {
        showAnimatedSkeleton(view: view, color: .clouds)
    }
    
    
    func responseDidRecieve() {}
    
}


// MARK: - SkeletonTableViewDataSource

extension CitiesViewController: SkeletonTableViewDataSource {

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        CitiesTableViewCell.nibName
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 15
        default:
            return 0
        }
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        2
    }
    
}


// MARK: - UITableViewDataSource

extension CitiesViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return cities.count
        default:
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CitiesTableViewCell.nibName, for: indexPath) as? CitiesTableViewCell {
            switch indexPath.section {
            case 0:
                 cell.configure(cityName: currentCity, isCurrent: true)
            case 1:
                cell.configure(cityName: cities[indexPath.row], isCurrent: false)
            default:
                ()
            }           
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CitiesConstants.tableViewHeaderHeight
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !citiesSectionsTitles.isEmpty,
            citiesSectionsTitles.endIndex >= section else { return nil }
        let headerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: tableView.frame.width,
                                              height: CitiesConstants.tableViewHeaderHeight))
        headerView.backgroundColor = CitiesConstants.lightGrey
        let label = UILabel()
        label.frame = CGRect.init(x: 15,
                                  y: 8,
                                  width: tableView.frame.width,
                                  height: 56)
        label.text = citiesSectionsTitles[section]
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular) 
        label.textColor = CitiesConstants.grey
        headerView.addSubview(label)
        return headerView
    }
    
}


// MARK: - UITableViewDelegate

extension CitiesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectCity(row: indexPath.row, isCurrent: indexPath.section == 0)
    }
    
}


// MARK: - NavigationBarConfigurationProtocol

extension CitiesViewController: NavigationBarConfigurationProtocol {
    
    func backButtonPressed() {
        presenter.popView()
    }

}

