//
//  SearchViewViewModel.swift
//  TwitterClone
//
//  Created by 김선호 on 9/2/24.
//

import Foundation
import Combine

class SearchViewViewModel{
    
    var subscriptions: Set<AnyCancellable> = []
    
    func search(with query: String, _ completion: @escaping ([TwitterUser]) -> Void) {
        DatabaseManager.shared.collectionUsers(search: query)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { users in
                completion(users)
            }
            .store(in: &subscriptions)
    }
}
