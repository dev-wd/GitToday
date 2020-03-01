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

// Fetch 눌렀을떄 주는 데이터 반영 -> fetch누르면 있던 없던 현재 있는 id 기준  데이터 반영
// 앱 처음 켰을 때에 데이터 반영 -> 있던 없던 현재 있는 id 기준 데이터 반영
// Id 새로 셋 해주면 데이터반영 -> 아이디 셋 해주고 따로 해주는 걸로 가야지

class CalendarViewModel: CalendarViewBindable {
    
    private let useCase: ContributionsUseCase = ContributionsUseCase()
    private let contributionsRepository: ContributionsRepository = ContributionsRepository.shared
    
    var todayCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var weekCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var monthCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    var step1: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    var step2: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    var step3: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    var step4: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    var step5: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    init() {
        
        
        
    }
    
    func fetch() {
        useCase.fetchContributions() { error  in
        self.todayCount.accept(self.contributionsRepository.todayCount)
            self.weekCount.accept(self.contributionsRepository.weekCount)
            self.monthCount.accept(self.contributionsRepository.monthCount)
            self.step1.accept(self.contributionsRepository.step1)
            self.step2.accept(self.contributionsRepository.step2)
            self.step3.accept(self.contributionsRepository.step3)
            self.step4.accept(self.contributionsRepository.step4)
            self.step5.accept(self.contributionsRepository.step5)
            
            print("refetch")
            // guard 문 활용 방안?
            if error == GitTodayError.userIDLoadError {
                
            }
            print(error)
            
        }
    }
    
    func fetchUpdate(id: String) {
        useCase.firstFetchContributions(id: id) { error in
            print(error)
            self.todayCount.accept(self.contributionsRepository.todayCount)
            self.weekCount.accept(self.contributionsRepository.weekCount)
            self.monthCount.accept(self.contributionsRepository.monthCount)
            self.step1.accept(self.contributionsRepository.step1)
            self.step2.accept(self.contributionsRepository.step2)
            self.step3.accept(self.contributionsRepository.step3)
            self.step4.accept(self.contributionsRepository.step4)
            self.step5.accept(self.contributionsRepository.step5)
            
        }
    }
}
