//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by Ios Developer on 17.12.2022.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    private var viewModel = AuthenticationViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let LoginTitleLabel:UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Login to your account"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
  
    lazy var emailTextField = CustomTextField(isSecureText: false, keyboardT: .emailAddress, placeHolderText: "email")
    lazy var passwordTextField = CustomTextField()
    
    private let LoginButton:UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 16,weight: .bold)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor(red: 29/255, green: 161/225, blue: 242/225, alpha: 1)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.isEnabled = false
        return button
    }()
    
    @objc func didChangeEmailField(){
        viewModel.email = emailTextField.text
        viewModel.validateAuthenticationForm()
    }
    @objc func didChangePasswordField(){
        viewModel.password = passwordTextField.text
        viewModel.validateAuthenticationForm()
    }
    
    
    private func bindViews(){//görünüm bağlayıcıları, kayıt görünümleri
        emailTextField.addTarget(self, action: #selector(didChangeEmailField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePasswordField), for: .editingChanged)
        viewModel.$isAuthenticationFormValid.sink { [weak self] validationState in//doğrulama durumu
            self?.LoginButton.isEnabled = validationState
        } //dolar işareti publushedi çagırır . sink senkronize işleri
        .store(in: &subscriptions) // temel olarak kayıtları depolucak. & işareti subscriptionsa referans verdigimiz için otomatik geliyo.
        
        viewModel.$user.sink { [weak self] user in//authenviewmodel de dolan user goruntulenir
            guard user != nil else {return}// gezinme denetleyicisinin içinde olan görünümü de ayarlamak için . BURDAN SONRA ADDTARGET REGİSTER BUTON YAPTIK
            guard let vc = self?.navigationController?.viewControllers.first as? OnboardingViewController else {return}
            vc.dismiss(animated: true)
        }
        .store(in: &subscriptions)//subs u set içinde saklıcaz
       
        viewModel.$error.sink { [weak self] errorString in //
            guard let error = errorString else {return}
            self?.presentAlert(with: error)
        }
        .store(in: &subscriptions)
    }
    
    private func presentAlert(with error:String){ // HATA BOLONCUK KUTUSUNU ÇIKARIYOR ERROR BAŞLIGI ALTINDA AUTHENTİCATİONDA İSE HATA SEBEBİNİ YAZDIRIO
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okeyButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okeyButton)
        present(alert, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        loginLabelConfiguration()
        emailTextFieldConfiguration()
        passwordTextFieldConfiguration()
        loginButtonConfiguration()
        bindViews()
    }
    


    private func loginLabelConfiguration(){
        view.addSubview(LoginTitleLabel)
        
        NSLayoutConstraint.activate([
            LoginTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            LoginTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20)
        ])
    }
    private func emailTextFieldConfiguration(){
        view.addSubview(emailTextField)
        
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 60),
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            emailTextField.topAnchor.constraint(equalTo: LoginTitleLabel.bottomAnchor,constant: 20)
        ])
    }
    private func passwordTextFieldConfiguration(){
        view.addSubview(passwordTextField)
        
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60),
            passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,constant: 20)
        ])
    }
    
    private func loginButtonConfiguration(){
        view.addSubview(LoginButton)
        LoginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            LoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            LoginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 20),
            LoginButton.heightAnchor.constraint(equalToConstant: 50),
            LoginButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    @objc func didTapLogin(){
        viewModel.loginUser()
    }
}
