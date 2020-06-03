//
//  OperationsFilterViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit
import BEMCheckBox


class OperationsFilterViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: OperationsFilterPresenterProtocol!
    var configurator: OperationsFilterConfiguratorProtocol!
    
    lazy var markers: [OperationFilter: BEMCheckBox] = [
        .waste: wasteMarker,
        .replenishOnline: replenishOnlineMarker,
        .replenishOffline: replenishOfflineMarker,
        .cashback: cashbackMarker,
        .all: allMarker
    ]
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.frame = self.view.frame
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var wasteMarker: BEMCheckBox!
    @IBOutlet weak var replenishOnlineMarker: BEMCheckBox!
    @IBOutlet weak var replenishOfflineMarker: BEMCheckBox!
    @IBOutlet weak var cashbackMarker: BEMCheckBox!
    @IBOutlet weak var allMarker: BEMCheckBox!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!

    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCloseButton()
        createClearButton()
        configureTextFields()
        configureCheckBoxes()
        _ = hideKeyboardWhenTapped()
        toTextField.tintColor = .clear
        fromTextField.tintColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear()
    }
 
    
    // MARK: Actions
    
    @IBAction func operationTypeDidChange(_ sender: Any) {
        if let view = sender as? BEMCheckBox,
            let operation = OperationFilter(rawValue: view.tag) {
            presenter.operationTypeDidChange(operation: operation)
        }
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        presenter.filterButtonPressed()
    }
    
    
    // MARK: - Private
    
    private func configureTextFields() {
        setLeftView(text: OperationFilterConstants.from,
                    textField: fromTextField)
        setLeftView(text: OperationFilterConstants.to,
                    textField: toTextField)
        fromTextField.delegate = self
        toTextField.delegate = self
        configureDatePicker(textField: fromTextField,
                            title: OperationFilterConstants.from,
                            doneSelector: #selector(self.fromDatePickerDone),
                            dateChangedSelector: #selector(self.fromDateChanged))
        configureDatePicker(textField: toTextField,
                            title: OperationFilterConstants.to,
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


    private func configureDatePicker(textField: UITextField, title: String, doneSelector: Selector, dateChangedSelector: Selector) {
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
//        datePicker.calendar = Calendar(identifier: .gregorian)
//          datePicker.date = Date()
        datePicker.addTarget(self, action: dateChangedSelector, for: .allEvents)
        textField.inputView = datePicker
        datePicker.backgroundColor = .white

    
        let locale = Locale(identifier: "ru")
        datePicker.locale = locale
        datePicker.translatesAutoresizingMaskIntoConstraints = false
//        datePicker.removeFromSuperview( )
        datePicker.datePickerMode = .date

        let button = UIButton()
        button.frame.size = CGSize(width: 60, height: 68)
        button.setTitle(OperationFilterConstants.done, for: .normal)
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


        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: currentWindow.frame.width, height: 68))
        toolBar.setItems([toolBarTitle,
                          UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                          doneButton], animated: true)
        toolBar.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
        toolBar.clipsToBounds = true
        toolBar.barTintColor = .white
        toolBar.backgroundColor = .white

//        toolBar.removeFromSuperview()
        textField.inputAccessoryView = toolBar
    }
    
    
    private func configureCheckBoxes() {
        markers.forEach { (args) in
            args.value.onAnimationType = .oneStroke
            args.value.offAnimationType = .oneStroke
        }
    }

    
    @objc private func fromDatePickerDone() {
        fromTextField.resignFirstResponder()
    }
    
    @objc private func fromDateChanged() {
        if let datePicker = fromTextField.inputView as? UIDatePicker {
            presenter.fromDateChanged(date: datePicker.date)
        }
    }
    
    @objc private func toDatePickerDone() {
        toTextField.resignFirstResponder()
    }
    
    @objc private func toDateChanged() {
        if let datePicker = toTextField.inputView as? UIDatePicker {
            presenter.toDateChanged(date: datePicker.date)
        }
    }

}


// MARK: - OperationsFilterViewProtocol

extension OperationsFilterViewController: OperationsFilterViewProtocol {
    
    func setDate(from: String, date: Date?) {
        fromTextField.text = from
        if let date = date,
            let datePicker = fromTextField.inputView as? UIDatePicker {
            datePicker.date = date
        }
    }
    
    func setDate(to: String, date: Date?) {
        toTextField.text = to
        if let date = date,
            let datePicker = toTextField.inputView as? UIDatePicker {
            datePicker.date = date
        }
    }
    
    func setMarker(operations: [OperationFilter]) {
        markers.forEach { (args) in
            let (operationType, markerView) = args
            let isOn = operations.contains(operationType)
            if markerView.on != isOn {
                markerView.setOn(isOn, animated: true)
            }
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
    
}
