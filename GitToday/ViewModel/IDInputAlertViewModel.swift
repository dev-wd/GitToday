//
//  IDInputAlertViewModel.swift
//  GitToday
//
//  Created by Mainea on 3/1/20.
//  Copyright © 2020 Mainea. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import JGProgressHUD

enum ResponseStatus {
    case success
    case failed(Error)
}

protocol IDInputAlertViewBindable {
    var input: BehaviorRelay<String> { get }
    var isLoading: PublishRelay<Bool> { get }
    var responseStatus: PublishRelay<ResponseStatus> { get }
    var doneButtonValidation: BehaviorRelay<Bool> { get }
    func fetch()
}

class IDInputAlertViewModel: IDInputAlertViewBindable {
    
    private let useCase: ContributionsUseCase = ContributionsUseCase()
    private let contributionsRepository: ContributionsRepository = ContributionsRepository.shared
    
    var input: BehaviorRelay<String>
    var isLoading: PublishRelay<Bool>
    var responseStatus: PublishRelay<ResponseStatus>
    var doneButtonValidation: BehaviorRelay<Bool>
    
    init() {
        input = BehaviorRelay(value: "")
        isLoading = PublishRelay.init()
        responseStatus = PublishRelay.init()
        doneButtonValidation = BehaviorRelay(value: true)
    }
    func fetch() {
        isLoading.accept(true)
        let id = input.value
        useCase.firstFetchContributions(id: id) { error in
            if error == GitTodayError.userIDLoadError {
                
            }
        }
        
        // fetch 끝나고 난 다음에
        isLoading.accept(false)
        
    }
    
    
}
