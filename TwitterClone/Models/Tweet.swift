//
//  Tweet.swift
//  TwitterClone
//
//  Created by 김선호 on 8/20/24.
//

import Foundation

struct Tweet: Codable {
    let id: String
    let author: TwitterUser
    let tweetContent: String
    var likesCount: Int
    var likers: [String]
    let isReply: Bool
    let parentReference: String?
}
