//
//  MainProtocol.swift
//  carWash
//
//  Created by Juliett Kuroyan on 18.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import Foundation

// MARK: - View
protocol MainViewProtocol: class {
//   func updateFor(info: [CashbackTypeInfo])
    func set(name: String,
             balance: String)
    func updateCashbacks(progress: Float,
                         currentCashbackProgress: Float?,
                         nextCashbackProgress: Float?,
                         currentCashbackIndex: Int?,
                         description: String)
    func reload(rows: [Int]) 
    func reloadData()
    func setCahbackInfo(firstPercent: String, firstValue: String,
                        secondPercent: String, secondValue: String,
                        thirdPercent: String, thirdValue: String,
                        fourthPercent: String, fourthValue: String,
                        fifthPercent: String, fifthValue: String)
    func showAlert(message: String,
                   title: String,
                   okButtonTitle: String,
                   cancelButtonTitle: String,
                   okAction: @escaping () -> (),
                   cancelAction: @escaping () -> ())
    func configureTextFieldForName()
    func configureTextFieldForPhone()
    func selectCity(cities: [CityResponse])
}

// MARK: - Presenter
protocol MainPresenterProtocol: class {
    func presentPaymentView()
    func viewDidLoad()
    func logout()
    func loadPage(for row: Int)
    var operationsCount: Int { get }
    var operationsInfo: [OperationInfo?] { get }
    func getOperations()
    func selectCity()
    func nameEditindDidEnd(_ name: String?)
    func didSelectCity(row: Int)
}

// MARK: - Router
protocol MainRouterProtocol {
    func presentPaymentView()
    func popToAuthorization()
    func presentCityView()
}

// MARK: - Interactor
protocol MainInteractorProtocol: class {
    func getUserInfo(onSuccess: @escaping (UserResponse) -> (),
                     onFailure: @escaping () -> ()?)
    func logout(onSuccess: @escaping () -> (),
                onFailure: @escaping () -> ()?)
    func getOperations(page: Int,
                       qty: Int,
                       onSuccess: @escaping (UserOperationsResponse) -> (),
                       onFailure: @escaping () -> ()?)
    func changeName_(name: String,
                     onSuccess: @escaping (NameChangeResponse) -> (),
                     onFailure: @escaping () -> ()?)
    func getCities(onSuccess: @escaping ([CityResponse]) -> (),
                   onFailure: (() -> ())?)
}

// MARK: - Configurator
protocol MainConfiguratorProtocol {
    
}
