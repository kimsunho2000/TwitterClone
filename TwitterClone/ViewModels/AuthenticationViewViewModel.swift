//
//  RegisterViewViewModel.swift
//  TwitterClone
//
//  Created by 김선호 on 7/22/24.
//

import Foundation
import Firebase
import Combine

//ViewModel handle all the logic for the views it self(MVVM)

final class AuthenticationViewViewModel: ObservableObject { //Observe instances of classes and update the view when they change.
    
    @Published var email: String?
    @Published var password: String?
    @Published var isAuthenticationFormValid: Bool = false
    @Published var user: User?
    @Published var error: String?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func validateAuthenticationForm() { //bind to register button
        guard let email = email,
              let password = password else {
            isAuthenticationFormValid = false
            return
        }
        isAuthenticationFormValid = isValidEmail(email) && password.count >= 8
    }
    
    func isValidEmail(_ email: String) -> Bool { //referenced by stackoverflow
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func createUser() { //create User
        guard let email = email,
              let password = password else { return }
        AuthManager.shared.registerUser(with: email, password: password)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
            })
            .sink { [weak self] completion in //error handler
                
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
                
            } receiveValue : { [weak self] user in //prevent strong reference cycle
                self?.createRecord(for: user)
            }
            .store(in: &subscriptions)
    }
    
    func createRecord(for user: User) { //call collectionUsers(add: user) and do error handling or print state
        DatabaseManager.shared.collectionUsers(add: user)
            .sink {
                [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            }   receiveValue: {
                state in
                print("Adding user record to database: \(state)")
                }
            .store(in: &subscriptions)
    }
    
    func loginUser() { //login system
        guard let email = email,
              let password = password else { return }
        AuthManager.shared.loginUser(with: email, Password: password)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
            })
            .sink { [weak self] completion in //error handler
                
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
                
            } receiveValue : { [weak self] user in //prevent strong reference cycle
                self?.user = user
            }
            .store(in: &subscriptions)
    }
} 

