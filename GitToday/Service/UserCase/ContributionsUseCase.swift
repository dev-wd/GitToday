//
//  IDSettingUseCase.swift
//  GitToday
//
//  Created by Mainea on 2/4/20.
//  Copyright © 2020 Mainea. All rights reserved.
//

import Foundation

protocol FetchContributionsUseCaseProtocol {
    func firstFetchContributions(id: String, completion: @escaping (GitTodayError?)->Void)
    func fetchContributions(completion: @escaping (GitTodayError?)-> Void)
}


class ContributionsUseCase {
    let userIDAPI: UserIDAPI = UserIDAPI()
    private let contributionsRepository: ContributionsRepository = ContributionsRepository.shared
}

extension ContributionsUseCase: FetchContributionsUseCaseProtocol {
    func firstFetchContributions(id: String, completion: @escaping (GitTodayError?) -> Void) {
        userIDAPI.save(id, of: .id)
        completion(GitTodayError.userIDLoadError)
        
        contributionsRepository.fetchRepository(id: id) { error  in
            completion(error)
        }
    }
    
    func fetchContributions(completion: @escaping (GitTodayError?) -> Void) {
        let id: String? = userIDAPI.load(of: .id)
        guard id != nil else {
            completion(GitTodayError.userIDLoadError)
            return
            // 여기 주의해보자
        }
        contributionsRepository.fetchRepository(id: id!) { error  in
            completion(error)
        }
    }
}

// first fetch - usecase에서 id를 저장하는것과 contributionAPI를 실행하는것
// fetch - userDefault가 있는지 확인하고 있으면 Contrubution API를 실행시킨다.

// 이거 문제가 ContiributionRepository에서 바로 패치를 해줄것이냐
// 아니면 UseCase에서 해줄것이냐 이다.
// ContirubitionRepo는 ID를 어떻게 알지
// id도 어차피 받아오는 작업을 해야하니까 usecased에서 처리해주는게 맞고 ContirubutionRepo에서는
// IDSettingUseCase를 받아오는 것이 맞다.
// 아예 리파짓토리가 필요없지 않나?



// 일단 UserDefault API로 다가 저장, 삭제, 로드를 한다.
// 그러면 Repository에서는 뭘 해주고 Repository 저장, 삭제

// usecase 에서는 뭘 해줘야 하나 리파지토리에서 불러와서

/// ----------------> 여기는 ID
//view입장에서 id를 쳤다.
// viewModel에 전달
// usecase에 전달
// id를 저장하고 그 아이디로 ContributionAPI 실행


// fetch를 요구했다.
// viewModel에 전달
// usecase에 전달
// User Default가 있으면 ContributionAPI 실행
// 없으면 nil 줌

// -----------> 여기는 Noti
// 알람을 설정했다.
// viewModel
// usecase 전달
// userdefault에 저장

// 근데 알람은 어떻게 서비스 해주는거징...
// 이걸 알아야 load 로직도 구성이 된다.

// Timepicker 를 viewController 에서 해준다.
// viewmoel
// usecase of alarm
// usesrapi
// alarm은 한번만 셋해주는건데 user alarm설정을 몇번이나 해줘야하는건지?

