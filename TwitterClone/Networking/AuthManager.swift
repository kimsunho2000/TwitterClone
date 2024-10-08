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
    
    
    func registerUser(with email : String, password: String) -> AnyPublisher<User, any Error> {
        
        return Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
    func loginUser(with email : String, Password: String) -> AnyPublisher<User, any Error> {
        return Auth.auth().signIn(withEmail: email, password: Password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
}
