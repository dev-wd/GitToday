//
//  CalendarViewModel.swift
//  GitToday
//
//  Created by Mainea on 2/4/20.
//  Copyright © 2020 Mainea. All rights reserved.
//

import Foundation

// Fetch 눌렀을떄 주는 데이터 반영 -> fetch누르면 있던 없던 현재 있는 id 기준  데이터 반영
// 앱 처음 켰을 때에 데이터 반영 -> 있던 없던 현재 있는 id 기준 데이터 반영
// Id 새로 셋 해주면 데이터반영 -> 아이디 셋 해주고 따로 해주는 걸로 가야지

class CalendarViewModel: CalendarViewBindable {
    
    private let useCase: ContributionsUseCase = ContributionsUseCase()
    private let contributionsRepository: ContributionsRepository = ContributionsRepository.shared
    
    var todayCount: Int {
        return contributionsRepository.todayCount
    }
    
    var weekCount: Int {
        return contributionsRepository.weekCount
    }
    
    var monthCount: Int {
        return contributionsRepository.monthCount
        
    }
    
    var step1: [String] {
        return contributionsRepository.step1
    }
    
    var step2: [String] {
        return contributionsRepository.step2
    }
    
    var step3: [String] {
        return contributionsRepository.step3
    }
    
    var step4: [String] {
        return contributionsRepository.step4
    }
    
    var step5: [String] {
        return contributionsRepository.step5
    }
    
    func fetch() {
        useCase.fetchContributions() { error  in
            print(error)
        }
    }
    
    func fetchUpdate(id: String) {
        useCase.firstFetchContributions(id: id) { error in
            print(error)
        }
    }
    
    func fetchVal() {
        self.todayCount = contributionsRepository.todayCount
        self.weekCount = contributionsRepository.weekCount
        self.monthCount = contributionsRepository.monthCount
        
        self.step1 = contributionsRepository.step1
        self.step2 = contributionsRepository.step2
        self.step3 = contributionsRepository.step3
        self.step4 = contributionsRepository.step4
        self.step5 = contributionsRepository.step5
    }
    // view Model 에서 fetch usecase 해준 다음에, 페치가 된 컴플리션을 받는다면, repository에서 꺼내서 온다!!
    // 그리고 그 꺼내서 온거를 그대로  view단에 전달해주면 된다.
}
