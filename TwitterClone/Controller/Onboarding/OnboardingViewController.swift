//
//  OnboardingViewController.swift
//  TwitterClone
//
//  Created by Ios Developer on 14.12.2022.
//

import UIKit

class OnboardingViewController: UIViewController {

    private let welcomeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "See what's happening in the world right now."
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.textColor = .label
        return label
    }()
    
    private let createAccountButton:UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.setTitle("Create Account", for: .normal)
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.backgroundColor = UIColor(red: 29/255, green: 161/225, blue: 242/225, alpha: 1)
        return button
    }()
    
    private let promptLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Have an account already?"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private let loginButton:UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitle("Login", for: .normal)
        button.tintColor = UIColor(red: 29/255, green: 161/225, blue: 242/225, alpha: 1)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        welcomeLabelConfiguration()
        createAccountButtonConfiguration()
        promptLabelConfiguration()
        loginButtonConfiguration()
        
    }
    
    private func welcomeLabelConfiguration(){
        view.addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)
        ])
    }
    
    private func createAccountButtonConfiguration(){
        view.addSubview(createAccountButton)
        
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor,constant: 20),
            createAccountButton.widthAnchor.constraint(equalTo: welcomeLabel.widthAnchor,constant: -20 ),
            createAccountButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    @objc func didTapCreateAccount(){
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func promptLabelConfiguration(){
        view.addSubview(promptLabel)
        
        NSLayoutConstraint.activate([
            promptLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -60),
            promptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            
        ])
    }
    private func loginButtonConfiguration(){
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            loginButton.centerYAnchor.constraint(equalTo: promptLabel.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: promptLabel.trailingAnchor,constant: 10),
            
        ])
    }
    @objc func didTapLogin(){
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }


}
