//
//  TwitterUser.swift
//  TwitterClone
//
//  Created by 김선호 on 7/25/24.
//

import Foundation
import Firebase

struct TwitterUser: Codable {
    let id: String
    var displayName: String = ""
    var username: String = ""
    var followersCount: Int = 0
    var followingCount: Int = 0
    var createdOn: String
    var bio: String = ""
    var avatarPath: String = ""
    var isUserOnboarded: Bool = false
    
    
    init(from user: User) {
        self.id = user.uid
        self.createdOn = TwitterUser.dateFormatter.string(from: Date())
    }
    
    static let dateFormatter: DateFormatter = { //transform Date() return value
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
}

