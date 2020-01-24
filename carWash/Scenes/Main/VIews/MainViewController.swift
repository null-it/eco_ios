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
    var nameViewHeight: CGFloat!

    lazy var isSE: Bool = {
        let modelName = UIDevice.modelName
        return Constants.SE.contains(modelName)
    }()
    
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

    private lazy var reviewsBackgroundView: UIView = {
        let currentWindow: UIWindow = UIApplication.shared.keyWindow!
        let backgroundView = UIView(frame: currentWindow.frame)
        currentWindow.addSubview(backgroundView)
        backgroundView.frame.origin = CGPoint(x: 0, y: 0)
        backgroundView.backgroundColor = UIColor(hex: "000000")?.withAlphaComponent(0.5)
        return backgroundView
    }()
    
    private var sendReviewViews: [ReviewView] = [] {
        didSet {
            reviewsBackgroundView.isHidden = sendReviewViews.count == 0
        }
    }
    
    private lazy  var reviewTextViews: [ReviewTextView] = []
    
    
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
    @IBOutlet weak var nameView: UIView!
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
    @IBOutlet weak var cardAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIImageView!
    @IBOutlet weak var paymentButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var paymentButton: UIButton!

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
        configureCard()
       
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        presenter.viewDidLoad(notificationResponse: appDelegate.reviewNotificationResponse)
        appDelegate.didRecieveReviewNotificationResponse = { [weak self] in
            self?.presenter.didRecieveNotification(appDelegate.reviewNotificationResponse)
        }
       
    }
    
    override func viewDidLayoutSubviews() {
        if #available(iOS 11.0, *) {
            cashBackViewHeight = cashBackView.frame.height
            nameViewHeight = isSE ? nameView.frame.height : helloView.frame.height + nameView.frame.height
        }
        
        DispatchQueue.once(token: onceToken) {
            if #available(iOS 11.0, *) {} else { // !
                cashBackViewHeight = cashBackView.frame.height
                nameViewHeight = isSE ? nameView.frame.height : helloView.frame.height + nameView.frame.height
            }
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
        let cellNib = UINib(nibName: MainViewActionCell.nibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: MainViewActionCell.nibName)
        tableView.addObserver(self, forKeyPath: "contentSize", options: .old, context: nil)
        refreshControl.addTarget(self, action: #selector(refreshOperationsData(_:)), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        refreshControl.setValue(30, forKey: "_snappingHeight")

    }
    
    
    @objc private func refreshOperationsData(_ sender: Any) {
        presenter.refreshData()
    }
    
    
    private func configureCard() {
        if isSE {
            cardAspectRatio.isActive = false
//            cardView.layoutIfNeeded()
            cardView.heightAnchor.constraint(equalToConstant: 110).isActive = true
            paymentButtonBottomConstraint.constant = 33
            cardView.image = UIImage(named: "cardBackgroundSE")
            cardView.layoutIfNeeded()
            paymentButton.cornerRadius = 6
            helloView.isHidden = true
        }
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
        topViewCornerRadius()
    }
     
    private func topViewCornerRadius() {
        topView.layer.cornerRadius = MainSceneConstants.cornerRadius
        if #available(iOS 11, *) {
            topView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    
    private func set(view: UIView, hidden: Bool) {

//        var difference = view.frame.height
        var difference = view == nameView
            ? nameViewHeight!
            : cashBackViewHeight!
        
        if hidden {
            // difference.negate()
            difference = -difference
        }
        let newHeight = topView.frame.height + difference
        var newBounds = self.topView.bounds
        newBounds.size.height = newHeight
                
        UIView.animate(withDuration: MainSceneConstants.animationDuration,
                       animations: { [weak self] in
                        guard let self = self else { return }
                        
                        if view == self.nameView && !self.isSE {
                            self.helloView.isHidden = hidden
                            self.helloView.alpha = hidden ? 0 : 1
                        }
                        view.isHidden = hidden
                        view.alpha = hidden ? 0 : 1
                        
                        if hidden {
                            self.updateShadow(bounds: newBounds,
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
        topViewCornerRadius()
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
        
        if nameTextField.isFirstResponder {
            textFieldText = nameTextField.text
            nameTextField.placeholder = textFieldText
            nameTextField.text = ""
            return
        }
                
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
            .cgRectValue.height {
            updateRevieTextViewFrame(keyboardHeight: keyboardHeight)
        }
        
    }
    
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if nameTextField.isFirstResponder {
            if let text = nameTextField.text,
                text.isEmpty {
                nameTextField.text = textFieldText
            }
            nameTextField.resignFirstResponder()
            presenter.nameEditindDidEnd(nameTextField.text)
            return
        }
        updateRevieTextViewFrame(keyboardHeight: 0)
    }
    
    private func updateRevieTextViewFrame(keyboardHeight: CGFloat) {
        if let view  = reviewTextViews.last {
            let currentWindow: UIWindow = UIApplication.shared.keyWindow!
            let y = currentWindow.frame.height - view.frame.height - keyboardHeight
            view.frame.origin.y = y
        }
    }
    
    private func createReviewTextView() -> ReviewTextView {
        let reviewTextView: ReviewTextView = .fromNib()!
        let currentWindow: UIWindow = UIApplication.shared.keyWindow!
        let width = currentWindow.frame.width
        let height = reviewTextView.frame.height
        reviewTextView.frame.size = CGSize(width: width,
                                           height: height)
        
        return reviewTextView
    }
    
        
    @objc private func hideInfoViewIfNeeded() {
        showAlert(message: "Уверены, что хотите закрыть окно?",
                  title: "",
                  okButtonTitle: "Да",
                  cancelButtonTitle: "Отмена",
                  okAction: { [weak self] in
                    self?.hideInfoView()
        },
                  cancelAction: {})
    }
    
    // MARK: - Actions
    
    @IBAction func paymentButtonPressed(_ sender: Any) {
        presenter.presentPaymentView()
    }
    
    
    @IBAction func allOperationsButtonPressed(_ sender: Any) {
        presenter.allOperationsButtonPressed()
    }
    
}


//MARK: - MainViewProtocol

extension MainViewController: MainViewProtocol {
    
    func dataRefreshed() {
        refreshControl.endRefreshing() 
    }
    
    func showReviewView(price: String, date: String, address: String) -> Int {
        let currentWindow: UIWindow = UIApplication.shared.keyWindow!
        let reviewView: ReviewView = .fromNib()!
        reviewsBackgroundView.addSubview(reviewView)
        var y = currentWindow.frame.height - reviewView.frame.height
        let width = currentWindow.frame.width
        let height = reviewView.frame.height
        reviewView.frame.origin = CGPoint(x: 0, y: y)
        reviewView.frame.size = CGSize(width: width,
                                       height: height)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.hideInfoViewIfNeeded))
        swipeGesture.direction = .down
        reviewView.addGestureRecognizer(swipeGesture)
        sendReviewViews.append(reviewView)
        reviewView.configure(price: price, date: date, address: address)
        
        
        let reviewTextView = self.createReviewTextView()
        y = currentWindow.frame.height - reviewTextView.frame.height
        reviewTextView.frame.origin = CGPoint(x: 0, y: y)
        reviewTextView.doneButtonPressed = { [weak self] (text) in
            guard let self = self else { return }
            self.presenter?.didChange(reviewText: text, index: self.sendReviewViews.count - 1)
        }
        self.reviewTextViews.append(reviewTextView)
        
        reviewView.reviewButtonPressed = { [weak self] in
            self?.reviewsBackgroundView.addSubview(reviewTextView)
            reviewTextView.configure()

        }
        
        reviewView.doneButtonPressed = { [weak self] in
            guard let self = self else { return }
            self.presenter.reviewDoneButtonPressed(index: self.sendReviewViews.count - 1)
        }
        
        reviewView.ratingDidChanged = { [weak self] (rating) in
            guard let self = self else { return }
            self.presenter.ratingDidChanged(index: self.sendReviewViews.count - 1, rating: rating)
        }
        
        return self.sendReviewViews.count - 1
    }

    
    func hideInfoView() { // ! MOVE
    //        guard !infoView.isHidden else { return }
    //        move(up: false) { [weak self] in
    //            self?.infoView.isHidden = true
    //        }
    //        mapView.removeGestureRecognizer(tapGesture)
        
        sendReviewViews.last?.removeFromSuperview()
        sendReviewViews.removeLast()
        reviewTextViews.removeLast()
    }
    
    
    func didChange(reviewText: String, index: Int) {
        sendReviewViews[index].set(text: reviewText)
        reviewTextViews[index].removeFromSuperview()
    }
    
    

    
    func selectCity(cities: [CityResponse]) {
        let cityView: CityView = .fromNib()!
        cityView.presenter = presenter
        cityView.configure(cities: cities)
        let window = UIApplication.shared.keyWindow!
        cityView.frame = window.bounds
        window.addSubview(cityView)
        cityView.center = view.center
        cityView.hide = {
            cityView.removeFromSuperview()
        }
    }
    
    
    func configureTextFieldForName() {
        nameTextField.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        nameTextField.textColor = .black
    }
    
    
    func configureTextFieldForPhone() {
        nameTextField.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        nameTextField.textColor = UIColor(hex: "828282") // !
    }
    
    
    func set(name: String,
             balance: String) {
        nameTextField.backgroundColor = .clear
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
                label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                label.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
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
        let count = presenter.operationsInfo.count
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


//MARK: - UIScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let nameViewHeight = nameViewHeight,
            let cashBackViewHeight = cashBackViewHeight else {
                return
        }
        
        let spacing = scrollView.contentInset.top + scrollView.contentOffset.y
        let hideHelloView = spacing >= nameViewHeight
        let hideCashBackView =  spacing >= cashBackViewHeight + nameViewHeight
        
        if hideHelloView && !nameView.isHidden {
            set(view: nameView, hidden: true)
        } else if !hideHelloView && nameView.isHidden {
            set(view: nameView, hidden: false)
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
