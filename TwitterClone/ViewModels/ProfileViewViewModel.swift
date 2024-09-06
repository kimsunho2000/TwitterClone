//
//  ProfileViewViewModel.swift
//  TwitterClone
//
//  Created by 김선호 on 8/11/24.
//

import Foundation
import Combine
import FirebaseAuth

final class ProfileViewViewModel: ObservableObject {
    
    @Published var user: TwitterUser
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(user: TwitterUser) {
        self.user = user
        
    }
    
    func fetchUserTweets() { //fetch users tweets
        DatabaseManager.shared.collectionTweets(retreiveTweets: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            }   receiveValue: { [weak self] tweets in
                self?.tweets = tweets
            }
            .store(in: &subscriptions)
    }
}


