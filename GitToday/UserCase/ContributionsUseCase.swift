//
//  IDSettingUseCase.swift
//  GitToday
//
//  Created by Mainea on 2/4/20.
//  Copyright © 2020 Mainea. All rights reserved.
//

import Foundation

protocol FetchContributionsUseCaseProtocol {
    func firstFetchContributions(id: String, completion: @escaping (GitTodayError?, _ id: String?)->Void)
    func fetchContributions(completion: @escaping (GitTodayError?, _ id: String?) -> Void)
}


class ContributionsUseCase {
    let userIDAPI: UserIDAPI = UserIDAPI()
    private let contributionsRepository: ContributionsRepository = ContributionsRepository.shared
}

extension ContributionsUseCase: FetchContributionsUseCaseProtocol {
    func firstFetchContributions(id: String, completion: @escaping (GitTodayError?,  _ id: String? ) -> Void) {
        contributionsRepository.fetchRepository(id: id) { error  in
            guard error != GitTodayError.networkError else {
                let id: String? = self.userIDAPI.load(of: .id)
                completion(error, id)
                return
            }
            
            self.userIDAPI.save(id, of: .id)
            completion(error, id)
        }
        
    }
    
    func fetchContributions(completion: @escaping (GitTodayError?, _ id: String?) -> Void) {
        let id: String? = self.userIDAPI.load(of: .id)
        guard id != nil else {
            completion(GitTodayError.userIDLoadError, nil)
            return
        }
        contributionsRepository.fetchRepository(id: id!) { error  in
            completion(error, id)
        }
    }
}
