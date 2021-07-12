//
//  MainViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 18.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import SkeletonView
import YooKassaPayments

class MainViewController: UIViewController {

    // MARK: - Properties
    
    var presenter: MainPresenterProtocol!
    var configurator: MainConfiguratorProtocol!

    lazy var isSE: Bool = {
        let modelName = UIDevice.modelName
        return Constants.SE.contains(modelName)
    }()
    
    let onceToken = "mainViewConfiguration"
    var textFieldText: String?
     
    private var refreshControl: UIRefreshControl!

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
    
    private lazy var reviewTextViews: [ReviewTextView] = []
    
    private var userInfoRequestStartDate: Date!
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var helloView: UIView!
    @IBOutlet weak var cashBackView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var operationsViewTitle: UILabel!
    @IBOutlet weak var cardAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIImageView!
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var operationsWrapper: UIView!
    @IBOutlet weak var balanceLabelWrapper: UIView!
    @IBOutlet weak var paymentButtonWrapper: UIView!
        
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var promocodeTextField: UITextField!
    @IBOutlet weak var promocodeButton: UIButton!
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        nameTextField.delegate = self
        _ = hideKeyboardWhenTapped()
        addObservers()
        configureTableView()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionLabel.text = appVersion ?? "N.N.N"
        createExitButton()
        createLocationButton()
        configureCard()
        promocodeTextField.setLeftPadding(8)
        promocodeTextField.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        presenter.viewDidLoad(notificationResponse: appDelegate.reviewNotificationResponse)
        appDelegate.didRecieveReviewNotificationResponse = { [weak self] in
            self?.presenter.didRecieveNotification(appDelegate.reviewNotificationResponse)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        configureRefreshControl()
        scrollView.setContentOffset(.zero, animated: true)
        AppUpdater.shared.showUpdate(withConfirmation: false)
    }
    
    override func viewDidLayoutSubviews() {
        view.layoutSkeletonIfNeeded()
                
//        DispatchQueue.once(token: onceToken) {
//            configureOperationsView()
//        }
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
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: MainViewActionCell.nibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: MainViewActionCell.nibName)
        tableView.addObserver(self, forKeyPath: "contentSize", options: .old, context: nil)
    }
    
    
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshOperationsData(_:)), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        refreshControl.setValue(Constants.refreshControlValue, forKey: "_snappingHeight")
    }
    
    
    @objc private func refreshOperationsData(_ sender: Any) {
        presenter.refreshData()
    }
    
    @objc private func willEnterForeground() {
        AppUpdater.shared.showUpdate(withConfirmation: false)
    }
    
    private func configureCard() {
        if isSE {
            cardAspectRatio.isActive = false
//            cardView.layoutIfNeeded()
            cardView.heightAnchor.constraint(equalToConstant: 110).isActive = true
            cardView.image = UIImage(named: "cardBackgroundSE")
            cardView.layoutIfNeeded()
            paymentButton.cornerRadius = 6
            helloView.isHidden = true
        }
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
        } else {
            tableView.backgroundView = nil
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
    
    
    private func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
//        guard seconds > 0 else {
//            completion()
//            return
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
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
        let amount = Amount(value: 999.99, currency: .rub)
        let tokenizationModuleInputData =
            TokenizationModuleInputData(clientApplicationKey: paymentToken,
                                        shopName: "Космические объекты",
                                        purchaseDescription: """
                                                                    Комета повышенной яркости, период обращения — 112 лет
                                                                    """,
                                        amount: amount,
                                        savePaymentMethod: .on)
        
        let inputData: TokenizationFlow = .tokenization(tokenizationModuleInputData)
        
        let viewController = TokenizationAssembly.makeModule(inputData: inputData,
                                                             moduleOutput: self)
        present(viewController, animated: true, completion: nil)
        //        presenter.presentPaymentView()
    }
    
    
    @IBAction func allOperationsButtonPressed(_ sender: Any) {
        presenter.allOperationsButtonPressed()
    }
    
    @IBAction func startWashPressed(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func promocodeButtonPressed(_ sender: Any) {
        presenter.sendPromocodeTapped()
    }
    
}


//MARK: - MainViewProtocol

extension MainViewController: MainViewProtocol {
    
    func promocodeTyping() {
        promocodeTextField.borderColor = UIColor(hex: "009EFE")
        promocodeButton.backgroundColor = UIColor(hex: "009EFE")
    }
    
    func promocodeFieldIsEmpty() {
        promocodeTextField.borderColor = UIColor(hex: "848688")
        promocodeButton.backgroundColor = UIColor(hex: "93C13D")
    }
    
    func requestSended() {
        view.activityStartAnimating(activityColor: .gray, backgroundColor: UIColor.lightGray.withAlphaComponent(0.5))
    }
    
    func responseReceived() {
        view.activityStopAnimating()
        presenter.refreshData()
    }
    
    func userInfoRequestDidSend() { // !!!
        nameView.clipsToBounds = true
        userInfoRequestStartDate = Date()
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight, duration:  MainSceneConstants.sceletonAnimationDuration) // !!!
        cardView.isSkeletonable = false
        paymentButtonWrapper.isSkeletonable = false
        balanceLabelWrapper.isSkeletonable = false
        stackView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: .clouds), animation: animation)
        cardView.isSkeletonable = true
        cardView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: Constants.green!), animation: animation)
        paymentButtonWrapper.isSkeletonable = true
        balanceLabelWrapper.isSkeletonable = true
        balanceLabelWrapper.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: Constants.lightGreen!), animation: animation)
        paymentButtonWrapper.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: Constants.lightGreen!), animation: animation)
    }
    
    
    func userInfoResponseDidRecieve(completion: (() -> ())?) {
        delayWithSeconds(MainSceneConstants.minDelay * 2) { [weak self] in
            self?.stackView.hideSkeleton()
            self?.cardView.hideSkeleton()
            self?.balanceLabelWrapper.hideSkeleton()
            self?.paymentButtonWrapper.hideSkeleton()
            self?.nameView.clipsToBounds = false
            completion?()
        }
    }
    
    
    func operationsRequestDidSend() {
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight,
                                                                        duration: MainSceneConstants.sceletonAnimationDuration) // !!!
        operationsWrapper.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: .clouds),
                                                       animation: animation)
    }
   
    
    func operationsResponseDidRecieve(completion: (() -> ())?) {
        delayWithSeconds(MainSceneConstants.minDelay) { [weak self] in
            self?.operationsWrapper.hideSkeleton()
            completion?()
        }
    }
    
    
    func dataRefreshed() {
        refreshControl.endRefreshing() 
    }
    
    func dataRefreshingError() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.scrollView.setContentOffset(.zero, animated: true)
        }
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
        
        reviewView.closeButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.sendReviewViews.forEach({$0.removeFromSuperview()})
            self.sendReviewViews.removeAll()
            self.reviewTextViews.removeAll()
        }
        
        return self.sendReviewViews.count - 1
    }

    
    func hideInfoView() { // ! MOVE (info?)
    //        guard !infoView.isHidden else { return }
    //        move(up: false) { [weak self] in
    //            self?.infoView.isHidden = true
    //        }x
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
    
}


//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MainSceneConstants.actionTableViewCellHeight
    }
    
}


//MARK: - SkeletonTableViewDataSource

extension MainViewController: SkeletonTableViewDataSource {
        
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        MainViewActionCell.nibName
    }
    
}



// MARK: - UITableViewDataSiurce

extension MainViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter.operationsInfo.count
        configureTableView(isEmpty: count == 0)
        return count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MainViewActionCell.nibName, for: indexPath)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == promocodeTextField {
            return presenter.shouldChangePromocodeCharacters(in: range, replacementString: string)
        } else if textField == nameTextField {
            return true
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == promocodeTextField {
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == promocodeTextField {
            promocodeFieldIsEmpty()
        }
    }
}


extension MainViewController: TokenizationModuleOutput {
    
    func didFinish(on module: TokenizationModuleInput, with error: YooKassaPaymentsError?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
    
    func didSuccessfullyPassedCardSec(on module: TokenizationModuleInput) {
        
    }
    
    func didSuccessfullyConfirmation(paymentMethodType: PaymentMethodType) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // Создать экран успеха после прохождения подтверждения (3DS или Sberpay)
            self.dismiss(animated: true)
            // Показать экран успеха
        }
    }
    
    func tokenizationModule(_ module: TokenizationModuleInput, didTokenize token: Tokens, paymentMethodType: PaymentMethodType) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        // Отправьте токен в вашу систему
    }
    
}
