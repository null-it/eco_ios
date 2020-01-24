//
//  OperationsFilterViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit


class OperationsFilterViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: OperationsFilterPresenterProtocol!
    var configurator: OperationsFilterConfiguratorProtocol!
    
    lazy var markers: [OperationFilter: UIView] = [
        .waste: wasteMarker,
        .replenishOnline: replenishOnlineMarker,
        .replenishOffline: replenishOfflineMarker,
        .cashback: cashbackMarker,
        .all: allMarker
    ]
    
    var toDatePicker: UIDatePicker!
    var fromDatePicker: UIDatePicker!

    lazy var backgroundView: UIView = {
        let view = UIView()
        view.frame = self.view.frame
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    // MARK: - Outlets
    
    @IBOutlet weak var wasteMarker: UIView!
    @IBOutlet weak var replenishOnlineMarker: UIView!
    @IBOutlet weak var replenishOfflineMarker: UIView!
    @IBOutlet weak var cashbackMarker: UIView!
    @IBOutlet weak var allMarker: UIView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!

    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCloseButton()
        createClearButton()
        configureTextFields()
        _ = hideKeyboardWhenTapped()
        toTextField.tintColor = .clear
        fromTextField.tintColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewDidLoad()
    }
 
    
    // MARK: Actions
    
    @IBAction func operationTypeDidChange(_ sender: UITapGestureRecognizer) {
        if let view = sender.view,
            let operation = OperationFilter(rawValue: view.tag) {
            presenter.operationTypeDidChange(operation: operation)
        }
    }
    
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        presenter.filterButtonPressed()
    }
    
    
    // MARK: - Private
    
    private func configureTextFields() {
        setLeftView(text: "От", textField: fromTextField)
        setLeftView(text: "До", textField: toTextField)
        fromTextField.delegate = self
        toTextField.delegate = self
        fromDatePicker = configureDatePicker(textField: fromTextField,
                                             title: "От",
                                             doneSelector: #selector(self.fromDatePickerDone),
                                             dateChangedSelector: #selector(self.fromDateChanged))
        toDatePicker = configureDatePicker(textField: toTextField,
                                           title: "До",
                                           doneSelector: #selector(self.toDatePickerDone),
                                           dateChangedSelector: #selector(self.toDateChanged))
    }
    
    
    private func setLeftView(text: String, textField: UITextField) {
        let label = UILabel()
        label.text = text
        label.font =  UIFont.systemFont(ofSize: 16, weight: .regular)
        label.sizeToFit()
        textField.leftView = label
        textField.leftViewMode = .always
    }


    private func configureDatePicker(textField: UITextField, title: String, doneSelector: Selector, dateChangedSelector: Selector) -> UIDatePicker {
        let datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: dateChangedSelector, for: .allEvents)
        datePicker.backgroundColor = .white
        let locale = Locale(identifier: "ru")
        datePicker.locale = locale
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        textField.inputView = datePicker

        let button = UIButton()
        button.frame.size = CGSize(width: 60, height: 68)
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Constants.green, for: .normal)
        button.addTarget(self, action: doneSelector, for: .touchUpInside)
        let doneButton = UIBarButtonItem(customView: button)
        
        
        let currentWindow: UIWindow = UIApplication.shared.keyWindow!

        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold) 
        label.sizeToFit()
        let width: CGFloat = (currentWindow.frame.width  + label.frame.width) / 2
        label.frame.size.width = width
        label.textAlignment = .right

        label.backgroundColor = .clear
        let toolBarTitle = UIBarButtonItem(customView: label)
        
        
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: currentWindow.frame.width, height: 68))
        toolBar.setItems([toolBarTitle,
                          UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                          doneButton], animated: true)
        toolBar.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
        toolBar.clipsToBounds = true
        toolBar.barTintColor = .white
        toolBar.backgroundColor = .white

        textField.inputAccessoryView = toolBar
        return datePicker
    }
    
    
    @objc private func fromDatePickerDone() {
        fromTextField.resignFirstResponder()
    }
    
    @objc private func fromDateChanged() {
        presenter.fromDateChanged(date: fromDatePicker.date)
    }
    
    @objc private func toDatePickerDone() {
        toTextField.resignFirstResponder()
    }
    
    @objc private func toDateChanged() {
        presenter.toDateChanged(date: toDatePicker.date)
    }


}


// MARK: - OperationsFilterViewProtocol

extension OperationsFilterViewController: OperationsFilterViewProtocol {
    
    func setDate(from: String, date: Date?) {
        fromTextField.text = from
        if let date = date {
            fromDatePicker.date = date
        }
    }
    
    
    func setDate(to: String, date: Date?) {
        toTextField.text = to
        if let date = date {
            toDatePicker.date = date
        }
    }
    
    
    func setMarker(operations: [OperationFilter]) {
        markers.forEach { (args) in
            let (operationType, markerView) = args
            markerView.backgroundColor = operations.contains(operationType)
                ? Constants.green
                : Constants.grey
        }
    }
}


// MARK: - NavigationBarConfigurationProtocol

extension OperationsFilterViewController: NavigationBarConfigurationProtocol {
    
    func closeButtonPressed() {
        presenter.popView()
    }
    
    func clearButtonPressed() {
        presenter.clearFields()
    }
    
}



// MARK: - UITextFieldDelegate

extension OperationsFilterViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.addSubview(backgroundView)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        backgroundView.removeFromSuperview()
    }
    
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        switch textField {
//        case toTextField:
//            return presenter.toDateTextFieldShouldClear()
//        case fromTextField:
//            return presenter.fromDateTextFieldShouldClear()
//        default:
//            return false
//        }
//    }
    
}
