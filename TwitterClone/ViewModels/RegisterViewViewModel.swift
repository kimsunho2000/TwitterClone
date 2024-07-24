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

final class RegisterViewViewModel: ObservableObject { //Observe instances of classes and update the view when they change.
    
    @Published var email: String?
    @Published var password: String?
    @Published var isRegistrationFormValid: Bool = false
    @Published var user: User?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func validateRegistrationForm() { //bind to register button
        guard let email = email,
              let password = password else {
            isRegistrationFormValid = false
            return
        }
        isRegistrationFormValid = isValidEmail(email) && password.count >= 8
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
            .sink { _ in
            } receiveValue : { [weak self] user in //prevent strong reference cycle
                self?.user = user
            }
            .store(in: &subscriptions)
    }
}

