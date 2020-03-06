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
    func fetchContributions(completion: @escaping (GitTodayError?, _ id: String?) -> Void)
}


class ContributionsUseCase {
    let userIDAPI: UserIDAPI = UserIDAPI()
    private let contributionsRepository: ContributionsRepository = ContributionsRepository.shared
}

extension ContributionsUseCase: FetchContributionsUseCaseProtocol {
    func firstFetchContributions(id: String, completion: @escaping (GitTodayError?) -> Void) {
        userIDAPI.save(id, of: .id)
        contributionsRepository.fetchRepository(id: id) { error  in
            completion(error)
        }
        
    }
    
    func fetchContributions(completion: @escaping (GitTodayError?, _ id: String?) -> Void) {
        let id: String? = userIDAPI.load(of: .id)
        guard id != nil else {
            completion(GitTodayError.userIDLoadError, nil)
            return
        }
        contributionsRepository.fetchRepository(id: id!) { error  in
            completion(error, id)
        }
    }
}
