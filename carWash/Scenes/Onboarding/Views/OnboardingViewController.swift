//
//  OnboardingViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import CHIPageControl

class OnboardingViewController: UIViewController {

    var presenter: OnboardingPresenterProtocol!
    var configurator: OnboardingConfiguratorProtocol!
    var info = [OnboardingInfo]()
    var isDragging = false
    lazy var pageControl: CHIPageControlJalapeno = {
        configurePageControl()
    }()

    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControlWrapper: UIView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureCollectionView()
    }
    
    
    // MARK: - Private
    
    private func configureNavigationBar() {
        createSkipButton()
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.borderColor = .clear
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(nibName: OnboardingCollectionViewCell.nibName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: OnboardingCollectionViewCell.nibName)
    }
    
    private func configurePageControl() -> CHIPageControlJalapeno {
        let pageControl = CHIPageControlJalapeno()
        pageControlWrapper.addSubview(pageControl)
        pageControl.frame.size = pageControlWrapper.frame.size
        pageControl.radius = MainSceneConstants.pageControlDotSize / 2
        pageControl.tintColor = MainSceneConstants.pageControlTintColor
        pageControl.currentPageTintColor = MainSceneConstants.pageControlCurrentPageTintColor
        pageControl.padding = MainSceneConstants.pageControlDotPadding
        return pageControl
    }
    
    // MARK: - Actions

    @IBAction func nextButtonPressed(_ sender: Any) {
        isDragging = false
        presenter.nextButtonPressed()
    }

}


// MARK: - OnboardingViewProtocol

extension OnboardingViewController: OnboardingViewProtocol {
    
    func updateFor(info: [OnboardingInfo]) {
        self.info = info
        pageControl.numberOfPages = info.count
        collectionView.reloadData()
    }
    
    func set(page: Int) {
        guard collectionView.numberOfItems(inSection: 0) > page else { return }
        pageControl.set(progress: page, animated: true)
        let indexPath = IndexPath(row: page, section: 0)
        if !collectionView.indexPathsForVisibleItems.contains(indexPath) {
            collectionView.scrollToItem(at: indexPath,
                                        at: .left,
                                        animated: true)
        }
    }
    
}


// MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return info.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.nibName, for: indexPath) as? OnboardingCollectionViewCell {
            cell.info = info[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
}


// MARK: - UIScrollViewDelegate

extension OnboardingViewController {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isDragging { return }
        var x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        x -= w / 2
        let index = Int(ceil(x/w))
        let currentIndex = min(index, info.count)
        presenter.currentPageDidChange(currentIndex)
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = collectionView.frame.height
        let size = CGSize(width: width, height: height)
        return size
    }
    
}


// MARK: - NavigationBarConfigurationProtocol

extension OnboardingViewController: NavigationBarConfigurationProtocol {
    
    func skipButtonPressed() {
        presenter.skipButtonPressed()
    }
    
}
