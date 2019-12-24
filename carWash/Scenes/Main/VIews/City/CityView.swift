//
//  CityView.swift
//  carWash
//
//  Created by Juliett Kuroyan on 24.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class CityView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    var presenter: MainPresenterProtocol!
    var cities: [CityResponse] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var hide: (() -> ())?
    var previousCell: CityViewCell?
    
    override func awakeFromNib() {
        configureTableView()
        setShadow()
    }
    
    private func setShadow() {
        let cornerRadius: CGFloat = 8
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: cornerRadius).cgPath
        contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowRadius = 10
    }
    
    private func configureTableView() {
        //        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: CityViewCell.nibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CityViewCell.nibName)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        hide?()
    }
    
}


extension CityView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CityViewCell.nibName, for: indexPath) as? CityViewCell {
            let city = cities[indexPath.row]
            cell.valueChanged = {[weak self] (selected) in
                if !selected {
                    self?.nextButton.isEnabled = false
                    self?.nextButton.setTitleColor(Constants.grey, for: .normal)
                    self?.previousCell = nil
                } else {
                    self?.previousCell?.set(selected: false)
                    self?.nextButton.isEnabled = true
                    self?.nextButton.setTitleColor(Constants.green, for: .normal)
                    self?.previousCell = cell
                    self?.presenter.didSelectCity(row: indexPath.row)
                }
            }
            cell.configure(name: city.city,
                           isSelected: city.isCurrent ?? false)
            return cell
        }
        return UITableViewCell()
    }
    
}
