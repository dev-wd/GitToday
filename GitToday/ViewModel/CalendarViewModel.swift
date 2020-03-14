//
//  CalendarViewModel.swift
//  GitToday
//
//  Created by Mainea on 2/4/20.
//  Copyright © 2020 Mainea. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CalendarViewModel: CalendarViewBindable {
    private let useCase: ContributionsUseCase = ContributionsUseCase()
    private let contributionsRepository: ContributionsRepository = ContributionsRepository.shared
    
    var id: BehaviorRelay<String>
    
    var isLoading: PublishRelay<Bool>
    var responseStatus: PublishRelay<ResponseStatus>
    var doneButtonValidation: BehaviorRelay<Bool>
    
    var todayCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var weekCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var monthCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    var step1: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    var step2: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    var step3: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    var step4: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    var step5: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    init() {
        id = BehaviorRelay(value: "")
        isLoading = PublishRelay.init()
        responseStatus = PublishRelay.init()
        doneButtonValidation = BehaviorRelay(value: true)
    }
    
    func fetch() {
        isLoading.accept(true)
        useCase.fetchContributions() { error, id  in
            
            guard error != GitTodayError.userIDLoadError else {
                self.isLoading.accept(false)
                self.responseStatus.accept(.failed(error!))
                return
            }
            
            guard error != GitTodayError.networkError else {
                self.isLoading.accept(false)
                self.responseStatus.accept(.failed(error!))
                return
            }
            
            self.id.accept(id!)
            self.todayCount.accept(self.contributionsRepository.todayCount)
            self.weekCount.accept(self.contributionsRepository.weekCount)
            self.monthCount.accept(self.contributionsRepository.monthCount)
            
            self.step1.accept(self.contributionsRepository.step1)
            self.step2.accept(self.contributionsRepository.step2)
            self.step3.accept(self.contributionsRepository.step3)
            self.step4.accept(self.contributionsRepository.step4)
            self.step5.accept(self.contributionsRepository.step5)
            
            self.isLoading.accept(false)
            self.responseStatus.accept(.success)
        }
    }
    
    func fetchUpdate(id: String) {
        guard id != "" else {
            self.responseStatus.accept(.failed(GitTodayError.userIDDidNotInputError))
            return
        }
        
        
        
        isLoading.accept(true)
        useCase.firstFetchContributions(id: id) { error, id in
            self.id.accept(id ?? "")
            guard error != GitTodayError.userIDSaveError else {
                self.isLoading.accept(false)
                self.responseStatus.accept(.failed(error!))
                return
            }
            
            guard error != GitTodayError.networkError else {
                self.isLoading.accept(false)
                self.responseStatus.accept(.failed(error!))
                return
            }
            
            
            
            
            self.todayCount.accept(self.contributionsRepository.todayCount)
            self.weekCount.accept(self.contributionsRepository.weekCount)
            self.monthCount.accept(self.contributionsRepository.monthCount)
            
            self.step1.accept(self.contributionsRepository.step1)
            self.step2.accept(self.contributionsRepository.step2)
            self.step3.accept(self.contributionsRepository.step3)
            self.step4.accept(self.contributionsRepository.step4)
            self.step5.accept(self.contributionsRepository.step5)
            
            self.isLoading.accept(false)
            self.responseStatus.accept(.success)
        }
    }
}
