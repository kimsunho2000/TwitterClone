//
//  ProfileViewViewModel.swift
//  TwitterClone
//
//  Created by 김선호 on 8/11/24.
//

import Foundation
import Combine
import FirebaseAuth

enum ProfileFollowingState {
    case userIsFollowed
    case userIsUnfollowed
    case personal
}

final class ProfileViewViewModel: ObservableObject {
    
    @Published var user: TwitterUser
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    @Published var currentFollowingState: ProfileFollowingState = .personal
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(user: TwitterUser) {
        self.user = user
        checkIfFollowed()
    }
    
    private func checkIfFollowed() {
        guard let personalUserID = Auth.auth().currentUser?.uid,
              personalUserID != user.id //현재 로그인된 사용자가 자신을 팔로우 할 수 없도록함.
        else {
            currentFollowingState = .personal
            return
        }
        DatabaseManager.shared.collectionFollowings(isFollower: personalUserID, following: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            }
    receiveValue: { [weak self] isFollowed in
        self?.currentFollowingState = isFollowed ? .userIsFollowed : .userIsUnfollowed
    }
    .store(in: &subscriptions)
    }
    
    func unFollow(){
        guard let personalUserID = Auth.auth().currentUser?.uid else {
            return
        }
        DatabaseManager.shared.collectionFollowings(delete: personalUserID, following: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] isUnFollowed in
                self?.currentFollowingState = .userIsUnfollowed
            }
            .store(in: &subscriptions)
    }
    
    func follow() {
        guard let personalUserID = Auth.auth().currentUser?.uid else {
            return
        }
        DatabaseManager.shared.collectionFollowings(follower: personalUserID, following: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] isFollowed in
                self?.currentFollowingState = .userIsFollowed
            }
            .store(in: &subscriptions)
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


