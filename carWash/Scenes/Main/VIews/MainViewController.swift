//
//  MainViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 18.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {

    // MARK: - Properties
    
    var presenter: MainPresenterProtocol!
    var configurator: MainConfiguratorProtocol!
    var cashBackViewHeight: CGFloat!
    var helloViewHeight: CGFloat!

    let onceToken = "mainViewConfiguration"
    var textFieldText: String?
    
    lazy var cashbackLabels = [
         firstCashbackLabel,
         secondCashbackLabel,
         thirdCashbackLabel,
         fourthCashbackLabel,
         fifthCashbackLabel
     ]
    
    lazy var cashbackValueLabels = [
        firstCashbackValueLabel,
        secondCashbackValueLabel,
        thirdCashbackValueLabel,
        fourthCashbackValueLabel,
        fifthCashbackValueLabel
    ]
     
    private let refreshControl = UIRefreshControl()

    
    // MARK: - Outlets
    
    @IBOutlet weak var firstCashbackValueLabel: UILabel!
    @IBOutlet weak var secondCashbackValueLabel: UILabel!
    @IBOutlet weak var thirdCashbackValueLabel: UILabel!
    @IBOutlet weak var fourthCashbackValueLabel: UILabel!
    @IBOutlet weak var fifthCashbackValueLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var helloView: UIView!
    @IBOutlet weak var cashBackView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var operationsTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstCashbackLabel: UILabel!
    @IBOutlet weak var secondCashbackLabel: UILabel!
    @IBOutlet weak var thirdCashbackLabel: UILabel!
    @IBOutlet weak var fourthCashbackLabel: UILabel!
    @IBOutlet weak var fifthCashbackLabel: UILabel!
    
    
    
    @IBOutlet weak var cashbackProgressView: UIProgressView!
    @IBOutlet weak var currentCashbackIndicator: UIView!
    @IBOutlet weak var nextCashbackIndicator: UIView!
    @IBOutlet weak var currentCashbackXConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextCashbackXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var operationsViewTitle: UILabel!
    @IBOutlet weak var cashbackDescription: UILabel!
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        scrollView.delegate = self
        nameTextField.delegate = self
        _ = hideKeyboardWhenTapped()
        addObservers()
        configureTableView()
        createExitButton()
        createLocationButton()
        configureProgressView()

        cashBackViewHeight = cashBackView.frame.height
        helloViewHeight = helloView.frame.height
        
        presenter.viewDidLoad() // !
    }
    

//    override func viewDidAppear(_ animated: Bool) {
//        updateCashbacks(progress: 0.35, currentCashbackProgress: 0.25, nextCashbackProgress: 0.5, currentCashbackIndex: 1)
//    }
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.once(token: onceToken) {
            configureOperationsView()
            createTopViewShadow()
        }
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let object = object as? UITableView {
            if object == tableView {
                let height = tableView.contentSize.height
                tableViewHeight.constant = height == 0 ? MainSceneConstants.emptyTableViewHeight : height
            }
        }
    }
    
    
    deinit {
        removeObservers()
        DispatchQueue.removeToken(token: onceToken)
    }
    
    
    // MARK: - Private
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        let cellNib = UINib(nibName: MainViewActionCell.nibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: MainViewActionCell.nibName)
        tableView.addObserver(self, forKeyPath: "contentSize", options: .old, context: nil)
        refreshControl.addTarget(self, action: #selector(refreshOperationsData(_:)), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        refreshControl.setValue(30, forKey: "_snappingHeight")

    }
    
    
    @objc private func refreshOperationsData(_ sender: Any) {
        presenter.getOperations()
        refreshControl.endRefreshing()
    }
    
    
    private func createTopViewShadow() {
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowPath = UIBezierPath(roundedRect: topView.bounds,
                                                cornerRadius: MainSceneConstants.cornerRadius).cgPath
        topView.layer.shadowOffset = CGSize(width: MainSceneConstants.shadowOffsetX,
                                            height: MainSceneConstants.shadowOffsetY)
        topView.layer.shadowOpacity = MainSceneConstants.shadowOpacity
        topView.layer.shadowRadius = MainSceneConstants.shadowRadius
        topView.roundCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner],
                             radius: MainSceneConstants.cornerRadius)
    }
    
    
    private func set(view: UIView, hidden: Bool) {

//        var difference = view.frame.height
        var difference = view == helloView
            ? helloViewHeight!
            : cashBackViewHeight! // ! ios 10
        
        if hidden {
            // difference.negate()
            difference = -difference
        }
        let newHeight = topView.frame.height + difference
        var newBounds = self.topView.bounds
        newBounds.size.height = newHeight
                
        UIView.animate(withDuration: MainSceneConstants.animationDuration,
                       animations: { [weak self] in
                        view.isHidden = hidden
                        view.alpha = hidden ? 0 : 1
                        if hidden {
                            self?.updateShadow(bounds: newBounds,
                                               cornerRadius: MainSceneConstants.cornerRadius)
                        }
        }) { [weak self] (_) in
            if !hidden {
                self?.updateShadow(bounds: newBounds,
                                   cornerRadius: MainSceneConstants.cornerRadius)
            }
        }
        
    }
    
    private func updateShadow(bounds: CGRect, cornerRadius: CGFloat) {
        topView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
    
    
    private func configureProgressView() {
        currentCashbackIndicator.isHidden = true
        nextCashbackIndicator.isHidden = true
        cashbackProgressView.progress = 0
    }
    
    
    private func configureOperationsView() {
//        operationsTopConstraint.constant = topView.frame.height + 24 // !
//        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: topView.frame.height + 14, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = UIEdgeInsets(top: topView.frame.height + 14, left: 0, bottom: 0, right: 0)

        operationsViewTitle.isHidden = false
        tableView.isHidden = false
    }
    
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        tableView?.removeObserver(self, forKeyPath: "contentSize")
    }
    
    private func configureTableView(isEmpty: Bool) {
        if isEmpty {
            let backgroundView: EmptyTransactionsView = .fromNib()!
            tableView.backgroundView = backgroundView
            operationsViewTitle.isHidden = true
        } else {
            tableView.backgroundView = nil
            operationsViewTitle.isHidden = false
        }
    }
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        textFieldText = nameTextField.text
        nameTextField.placeholder = textFieldText
        nameTextField.text = ""
    }
    
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if let text = nameTextField.text,
            text.isEmpty {
            nameTextField.text = textFieldText
        }
        nameTextField.resignFirstResponder()
        presenter.nameEditindDidEnd(nameTextField.text)
    }
    
    // MARK: - Actions
    
    @IBAction func paymentButtonPressed(_ sender: Any) {
        presenter.presentPaymentView()
    }
    
}


//MARK: - MainViewProtocol

extension MainViewController: MainViewProtocol {
    
    func selectCity(cities: [CityResponse]) {
        let cityView: CityView = .fromNib()!
        cityView.presenter = presenter
        cityView.cities = cities
        let window = UIApplication.shared.keyWindow!
        cityView.frame = window.bounds
        window.addSubview(cityView)
        cityView.center = view.center
        cityView.hide = {
            cityView.removeFromSuperview()
        }
    }
    
    
    func configureTextFieldForName() {
        nameTextField.font = UIFont(name: "Gilroy-Bold", size: 22)
        nameTextField.textColor = .black
    }
    
    
    func configureTextFieldForPhone() {
        nameTextField.font = UIFont(name: "Gilroy-Medium", size: 22)
        nameTextField.textColor = UIColor(hex: "828282") // !
    }
    
    
    func set(name: String,
             balance: String) {
        nameTextField.text = name
        balanceLabel.text = balance
    }
    
    
    func updateCashbacks(progress: Float,
                         currentCashbackProgress: Float?,
                         nextCashbackProgress: Float?,
                         currentCashbackIndex: Int?,
                         description: String) {
        // hide indicators if needed
        
        cashbackLabels.forEach { (label) in
            label?.sizeToFit()
        }
        if let currentCashbackProgress = currentCashbackProgress {
            currentCashbackXConstraint.constant = cashbackProgressView.frame.width * CGFloat(currentCashbackProgress)
        }
        
        
        if let nextCashbackProgress = nextCashbackProgress {
            nextCashbackXConstraint.constant = cashbackProgressView.frame.width * CGFloat(nextCashbackProgress)
        }
        
        UIView.animate(withDuration: 1, animations: { [weak self] in
            guard let self = self else { return }
            self.cashbackProgressView.setProgress(progress, animated: true)
            if let currentCashbackIndex = currentCashbackIndex,
                let label = self.cashbackLabels[currentCashbackIndex] {
                label.textColor = .black
                label.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
            }
        }) { [weak self] (_) in
            self?.currentCashbackIndicator.isHidden = currentCashbackProgress == nil
            self?.nextCashbackIndicator.isHidden = nextCashbackProgress == nil
        }
        cashbackDescription.text = description
    }
    
    
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
    
    func setCahbackInfo(firstPercent: String, firstValue: String,
                        secondPercent: String, secondValue: String,
                        thirdPercent: String, thirdValue: String,
                        fourthPercent: String, fourthValue: String,
                        fifthPercent: String, fifthValue: String) {
        cashbackLabels[0]?.text = firstPercent
        cashbackLabels[1]?.text = secondPercent
        cashbackLabels[2]?.text = thirdPercent
        cashbackLabels[3]?.text = fourthPercent
        cashbackLabels[4]?.text = fifthPercent
        cashbackValueLabels[0]?.text = firstValue
        cashbackValueLabels[1]?.text = secondValue
        cashbackValueLabels[2]?.text = thirdValue
        cashbackValueLabels[3]?.text = fourthValue
        cashbackValueLabels[4]?.text = fifthValue
    }
    
}


//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    
}


//MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter.operationsCount
        configureTableView(isEmpty: count == 0)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewActionCell", for: indexPath)
            as? MainViewActionCell {
            if let info = presenter.operationsInfo[indexPath.row] {
                let image = UIImage(named: info.imageName)
                cell.configure(image: image,
                               title: info.title,
                               sum: info.sum)
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

extension MainViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            //            if presenter.getOperation(row: indexPath.row) == nil { // move to presenter
                            presenter.loadPage(for: indexPath.row)
            //            }
        }
    }
}


//MARK: - UIScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let helloViewHeight = helloViewHeight,
            let cashBackViewHeight = cashBackViewHeight else {
                return
        }
        
        let spacing = scrollView.contentInset.top + scrollView.contentOffset.y
        let hideHelloView = spacing >= helloViewHeight
        let hideCashBackView =  spacing >= cashBackViewHeight + helloViewHeight
        
        if hideHelloView && !helloView.isHidden {
            set(view: helloView, hidden: true)
        } else if !hideHelloView && helloView.isHidden {
            set(view: helloView, hidden: false)
        }
        
        if hideCashBackView && !cashBackView.isHidden {
            set(view: cashBackView, hidden: true)
        } else if !hideCashBackView && cashBackView.isHidden {
            set(view: cashBackView, hidden: false)
        }
    }
    
}


// MARK: - NavigationBarConfigurationProtocol

extension MainViewController: NavigationBarConfigurationProtocol {

    @objc func exitButtonPressed() {
        presenter.logout()
    }

    @objc func locationButtonPressed() {
        presenter.selectCity()
    }
    
}


// MARK: - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}
