//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by 김선호 on 7/26/24.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    private var viewModel = AuthenticationViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let loginTitleLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Login to your Account"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private let emailTextField: UITextField = { //authentication methods that enabled from Google's Firebase
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textField.isSecureTextEntry = true //show password only black dots
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .twitterBlueColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.isEnabled = false
        return button
    }()
    
    @objc private func didChangeEmailField() {
        viewModel.email = emailTextField.text
        viewModel.validateAuthenticationForm()
    }
    
    @objc private func didChangePasswordField() {
        viewModel.password = passwordTextField.text
        viewModel.validateAuthenticationForm()
    }
    
    private func bindViews() {
        emailTextField.addTarget(self, action: #selector(didChangeEmailField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePasswordField), for: .editingChanged)
        viewModel.$isAuthenticationFormValid.sink { [weak self] validationState in
            self?.loginButton.isEnabled = validationState //binding crossed data between views and datamodels
        }
        .store(in: &subscriptions)
          
        viewModel.$user.sink { [weak self] user in //if user is't nill check first VC is OnboardingVC if user logined,OnboardingVC will dismissed
            guard user != nil else {
                return
            }
            guard let vc = self?.navigationController?.viewControllers.first as? OnboardingViewController else {
                return
            }
            vc.dismiss(animated: true)
        }
        .store(in: &subscriptions)
        viewModel.$error.sink {
            [weak self] errorString in
            guard let error = errorString else { return }
            self?.presentAlert(with: error)
        }
        .store(in: &subscriptions)
    }
    
    private func presentAlert(with error: String) { //if error occured,firebase will send error and alert will print that.
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "ok", style: .default)
        alert.addAction(okayButton)
        present(alert, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(loginTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        configureConstraints()
        bindViews()
    }
    
    @objc private func didTapLogin() {
        viewModel.loginUser()
    }
    
    private func configureConstraints() {
            
            let loginTitleLableConstraints = [
                loginTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loginTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
            ]
            
            let emailTextFieldConstraints = [
                emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                emailTextField.topAnchor.constraint(equalTo: loginTitleLabel.bottomAnchor, constant: 20),
                emailTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
                emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emailTextField.heightAnchor.constraint(equalToConstant: 60)
            ]
            
            let passwordTextFieldConstraints = [
                passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
                passwordTextField.widthAnchor.constraint(equalToConstant:  view.frame.width - 40),
                passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                passwordTextField.heightAnchor.constraint(equalToConstant: 60)
            ]
            
            let loginButtonConstraints = [
                loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
                loginButton.widthAnchor.constraint(equalToConstant: 180),
                loginButton.heightAnchor.constraint(equalToConstant: 50)
            ]
            
            NSLayoutConstraint.activate(loginTitleLableConstraints)
            NSLayoutConstraint.activate(emailTextFieldConstraints)
            NSLayoutConstraint.activate(passwordTextFieldConstraints)
            NSLayoutConstraint.activate(loginButtonConstraints)
    }
}

    
