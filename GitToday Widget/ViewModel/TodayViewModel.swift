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
    
    var isLoading: PublishSubject<Bool>
    var responseStatus: PublishSubject<ResponseStatus>
    var doneButtonValidation: BehaviorRelay<Bool>
    
    var todayCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var weekCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var monthCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    var step1: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    var step2: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    var step3: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    var step4: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    var step5: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    
    init() {
        isLoading = PublishSubject.init()
        responseStatus = PublishSubject.init()
        doneButtonValidation = BehaviorRelay(value: true)
    }
    
    func fetch() {
        self.isLoading.onNext(false)
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            Thread.printCurrent()
            self.useCase.fetchContributions() { error, id  in
                print("refetch")
                guard error != GitTodayError.userIDLoadError else {
                    self.isLoading.onNext(true)
                    self.responseStatus.onNext(.failed(error!))
                    print("viewModel fetch: ",error!)
                    return
                }
                self.todayCount.accept(self.contributionsRepository.todayCount)
                self.weekCount.accept(self.contributionsRepository.weekCount)
                self.monthCount.accept(self.contributionsRepository.monthCount)
                
                self.step1.onNext(self.contributionsRepository.step1)
                self.step2.onNext(self.contributionsRepository.step2)
                self.step3.onNext(self.contributionsRepository.step3)
                self.step4.onNext(self.contributionsRepository.step4)
                self.step5.onNext(self.contributionsRepository.step5)
                
                self.isLoading.onNext(true)
                self.responseStatus.onNext(.success)
                print("viewModel fetch: success")
            }
        }
    }
}
