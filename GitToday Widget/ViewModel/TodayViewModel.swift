//
//  TodayViewModel.swift
//  GitToday Widget
//
//  Created by Mainea on 1/31/20.
//  Copyright © 2020 Mainea. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TodayViewModel: TodayViewBindable {
    private let useCase: ContributionsUseCase = ContributionsUseCase()
    private let contributionsRepository: ContributionsRepository = ContributionsRepository.shared
    
    var isLoading: PublishRelay<Bool>
    // var responseStatus: PublishRelay<ResponseStatus>
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
        isLoading = PublishRelay.init()
        //responseStatus = PublishRelay.init()
        doneButtonValidation = BehaviorRelay(value: true)
    }
    
    func fetch() {
        isLoading.accept(true)
        useCase.fetchContributions() { error, id  in
            print("refetch")
            guard error != GitTodayError.userIDLoadError else {
                self.isLoading.accept(false)
                //self.responseStatus.accept(.failed(error!))
                print("GitTodayError.userIDLoadError")
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
            //self.responseStatus.accept(.success)
        }
    }
    
}
