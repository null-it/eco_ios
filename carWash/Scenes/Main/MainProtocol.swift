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
    func set(balance: String, cardNumber: String)
    func reload(rows: [Int]) 
    func reloadData()
    func showAlert(message: String,
                   title: String,
                   okButtonTitle: String,
                   cancelButtonTitle: String,
                   okAction: @escaping () -> (),
                   cancelAction: @escaping () -> ())
    func selectCity(cities: [CityResponse])
    func showReviewView(price: String, date: String, address: String) -> Int
    func didChange(reviewText: String, index: Int)
    func hideInfoView()
    func showAlert(message: String, title: String)
    func dataRefreshed()
    func dataRefreshingError()
    func userInfoRequestDidSend()
    func userInfoResponseDidRecieve(completion: (() -> ())?)
    func operationsRequestDidSend()
    func operationsResponseDidRecieve(completion: (() -> ())?)
    func showNetworkErrorMessage()
    func requestSended()
    func responseReceived()
    func promocodeTyping()
    func promocodeFieldIsEmpty()
}

// MARK: - Presenter
protocol MainPresenterProtocol: class {
    func shouldChangePromocodeCharacters(in range: NSRange,
                                   replacementString string: String) -> Bool
    func sendPromocodeTapped()
    func presentPaymentView()
    func viewDidLoad(notificationResponse: ReviewNotificationResponse?)
    func didRecieveNotification(_ notificationResponse: ReviewNotificationResponse?)
    var operationsInfo: [OperationInfo?] { get }
    func getOperations(isRefreshing: Bool)
    func logout()
    func selectCity()
    func didSelectCity(row: Int)
    func didChange(reviewText: String, index: Int)
    func didChange(reviewRating: Double, index: Int)
    func reviewDoneButtonPressed(index: Int)
    func ratingDidChanged(index: Int, rating: Double)
    func allOperationsButtonPressed()
    func refreshData() 
}

// MARK: - Router
protocol MainRouterProtocol {
    func presentPaymentView()
    func popToAuthorization()
    func presentCityView()
    func presentOperationsView()
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
    func postCity(city: String,
                  onSuccess: @escaping () -> (),
                  onFailure: @escaping () -> ()?)
    func postReview(userId: Int,
                    operationId: Int,
                    text: String,
                    stars: Double,
                    onSuccess: @escaping (ReviewResponse) -> (),
                    onFailure: @escaping () -> ()?)
    func applyPromocode(promocode: String,
                        onSuccess: @escaping (String, PromocodeStatus) -> (),
                        onFailure: (() -> ())?)
}

// MARK: - Configurator
protocol MainConfiguratorProtocol {
    
}
