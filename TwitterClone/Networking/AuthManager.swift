//
//  AuthManager.swift
//  TwitterClone
//
//  Created by 김선호 on 7/24/24.
//

import Foundation
import Firebase
import FirebaseAuthCombineSwift
import Combine

class AuthManager { //singleton pattern
    static let shared = AuthManager()
    
    
    func registerUser(with email : String, password: String) -> AnyPublisher<User, Error> {
        
        return Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
        
    }
}
