//
//  OnboardingPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

class OnboardingPresenter {
    
    unowned let view: OnboardingViewProtocol
    let router: OnboardingRouterProtocol
    var info = [
        OnboardingInfo(imagePath: "onboarding1", description: "Федеральная карта всех моек в одном приложении"),
        OnboardingInfo(imagePath: "onboarding2", description: "Получай кэшбэк с каждой мойки"),
        OnboardingInfo(imagePath: "onboarding3", description: "Отслеживай все операции по карте")
    ]
    var currentPage = 0
    

    init(view: OnboardingViewProtocol,
         router: OnboardingRouterProtocol) {
        self.view = view
        self.router = router
    }
    
}


extension OnboardingPresenter: OnboardingPresenterProtocol {
    
    func popView() {
        router.popView()
    }
    
    func viewDidLoad() {
        view.updateFor(info: info)
        view.set(page: currentPage)
    }
    
    func nextButtonPressed() {
        currentPage += 1
        if currentPage < info.count {
            view.set(page: currentPage)
        } else {
            router.presentLoginView()
        }
    }
    
    func currentPageDidChange(_ page: Int) {
        currentPage = page
        view.set(page: currentPage)
    }
    
    func skipButtonPressed() {
        router.presentLoginView()
    }

}
