//
//  ProfileDateFormViewViewModel.swift
//  TwitterClone
//
//  Created by 김선호 on 8/5/24.
//

import Foundation
import Combine

final class ProfileDateFormViewViewModel: ObservableObject {
    
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    
}
