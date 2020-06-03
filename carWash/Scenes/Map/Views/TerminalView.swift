//
//  WashingStartConfirmationView.swift
//  carWash
//
//  Created by Juliett Kuroyan on 10.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit

class TerminalView: UIView {
    
    // MARK: - Properties

    var terminalsCount: Int = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var didSelectTerminal: ((Int) -> ())?
    
    
    // MARK: - Outlets

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        configureCollectionView()
        roundCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 24)
    }
    
    
    // MARK: - Actions
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        
    }
    
    
    // MARK: - Private
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(nibName: TerminalCell.nibName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: TerminalCell.nibName)
    }
    
    
    func set(address: String, terminalsCount: Int) {
        self.terminalsCount = terminalsCount
        addressLabel.text = address
    }
    
}


// MARK: - UICollectionViewDelegate

extension TerminalView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectTerminal?(indexPath.row) // + 1
    }
    
}


// MARK: - UICollectionViewDataSource

extension TerminalView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return terminalsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TerminalCell.nibName, for: indexPath) as? TerminalCell {
            cell.set(text: "\(indexPath.row + 1)")
            return cell
        }
        return UICollectionViewCell()
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension TerminalView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 60 , height: 60)
        return size
    }
}
