//
//  RegisterViewController.swift
//  TwitterClone
//
//  Created by Ios Developer on 14.12.2022.
//

import UIKit
import Combine

class RegisterViewController: UIViewController {                    
    
    private var viewModel = AuthenticationViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    //abonalikleri tutacak combineyi import et . bu iptal edilebilir bir dizi olcak set<anycancellable

    private let registerTitleLabel:UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create your account"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
  
    lazy var emailTextField = CustomTextField(isSecureText: false, keyboardT: .emailAddress, placeHolderText: "email")
    lazy var passwordTextField = CustomTextField()
    
    private let registerButton:UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 16,weight: .bold)
        button.setTitle("Create account", for: .normal)
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
            self?.registerButton.isEnabled = validationState
        } //dolar işareti publushedi çagırır . sink senkronize işleri
        .store(in: &subscriptions) // temel olarak kayıtları depolucak. & işareti subscriptionsa referans verdigimiz için otomatik geliyo.
        
        viewModel.$user.sink { [weak self] user in
            guard user != nil else {return}// gezinme denetleyicisinin içinde olan görünümü de ayarlamak için . BURDAN SONRA ADDTARGET REGİSTER BUTON YAPTIK
            guard let vc = self?.navigationController?.viewControllers.first as? OnboardingViewController else {return}
            vc.dismiss(animated: true)
        }
        .store(in: &subscriptions)
        
        
        viewModel.$error.sink { [weak self] errorString in
            guard let error = errorString else {return}
            self?.presentAlert(with: error)
        }
        .store(in: &subscriptions)
    }
    
    private func presentAlert(with error:String){
        let alert = UIAlertController(title: "error", message: error, preferredStyle: .alert)
        let okeyButton = UIAlertAction(title: "ok", style: .default)
        alert.addAction(okeyButton)
        present(alert, animated: true)
    }

    @objc private func didTapToDismiss(){
        view.endEditing(true)//klavye kapatmak için
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        registerLabelConfiguration()
        emailTextFieldConfiguration()
        passwordTextFieldConfiguration()
        registerButtonConfiguration()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        bindViews()
    }
    private func registerLabelConfiguration(){
        view.addSubview(registerTitleLabel)
        
        NSLayoutConstraint.activate([
            registerTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20)
        ])
    }
    private func emailTextFieldConfiguration(){
        view.addSubview(emailTextField)
        
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 60),
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            emailTextField.topAnchor.constraint(equalTo: registerTitleLabel.bottomAnchor,constant: 20)
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
    
    private func registerButtonConfiguration(){
        view.addSubview(registerButton)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 20),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            registerButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    @objc func didTapRegister(){
        viewModel.createUser()
    }

    

}
