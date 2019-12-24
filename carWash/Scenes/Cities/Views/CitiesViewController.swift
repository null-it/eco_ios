//
//  CitiesViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 13.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

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
        title = "Выбор города" // !
    }
    
    
    // MARK: - Private
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: CitiesTableViewCell.nibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CitiesTableViewCell.nibName)
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
        tableView.reloadData()
    }
    
}


// MARK: - UITableViewDataSource

extension CitiesViewController: UITableViewDataSource {
    
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
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        guard !citiesSectionsTitles.isEmpty,
//            citiesSectionsTitles.endIndex >= section else { return nil }
//        return citiesSectionsTitles[section]
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56 // !
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !citiesSectionsTitles.isEmpty,
            citiesSectionsTitles.endIndex >= section else { return nil }
        let headerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: tableView.frame.width,
                                              height: 56)) // !
        headerView.backgroundColor = UIColor(hex: "#F4F6F9")
        let label = UILabel()
        label.frame = CGRect.init(x: 15,
                                  y: 8,
                                  width: tableView.frame.width,
                                  height: 56)
        label.text = citiesSectionsTitles[section]
        label.font = UIFont(name: "Gilroy-regular", size: 12)
        label.textColor = UIColor(hex: "#8D8D8D")
        headerView.addSubview(label)
        return headerView
    }
    
}


// MARK: - UITableViewDelegate

extension CitiesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectCity(row: indexPath.row)
    }
    
}


// MARK: - NavigationBarConfigurationProtocol

extension CitiesViewController: NavigationBarConfigurationProtocol {

    func backButtonPressed() {
        presenter.popView()
    }
    
}

