//
//  ProfileDataFromViewController.swift
//  TwitterClone
//
//  Created by Ios Developer on 18.12.2022.
//

import UIKit
import PhotosUI
import Combine

class ProfileDataFromViewController: UIViewController {
    
    private let viewModel = ProfileDataFormViewModel()
    private var subscriptions: Set<AnyCancellable> = []

    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag //klavye açıksa kaydırınca kapatır
        scrollView.alwaysBounceVertical = true // dik kaydırma
        return scrollView
        
    }()
    
    private let hintLabel:UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Fill in you data"
        label.font = .systemFont(ofSize: 32,weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let displayNameTextFieldLabel:UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.backgroundColor = .secondarySystemFill
        textField.leftViewMode = .always // dolgunluk kabartma gibi bi se verilecek bunlar gerekiyo
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.attributedPlaceholder = NSAttributedString(string: "Display Name",attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
        return textField
    }()
    
    private let usernameTextFieldLabel:UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.backgroundColor = .secondarySystemFill
        textField.leftViewMode = .always // dolgunluk kabartma gibi bi se verilecek bunlar gerekiyo
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.attributedPlaceholder = NSAttributedString(string: "Username",attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
        return textField
    }()
    
    private let avatarPlaceholderImageView:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 60
        image.backgroundColor = .lightGray
        image.image = UIImage(systemName: "camera.fill")
        image.tintColor = .gray
        image.isUserInteractionEnabled = true //kullanıcı etkilişimi olcak demek
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let bioTextView:UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .secondarySystemFill
        text.layer.masksToBounds = true
        text.layer.cornerRadius = 8
        text.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        text.text = "Tell the world about yourself"
        text.textColor = .gray
        text.font = .systemFont(ofSize: 16)
        return text
    }()
    
    private let submitButton:UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 16,weight: .bold)
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = UIColor(red: 29/255, green: 161/225, blue: 242/225, alpha: 1)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.isEnabled = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        isModalInPresentation = true // kullanıcı kkayıt ekranı tam sayfa değil. dolayısıyla aşağı kaydırılıyo onu çözmek için bu kodu yazdık.Artık tut çek yapılarak kapatılmıyor. azcık iniyo
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        
        configurationScrollView()
        configurationHintLabel()
        configurationAvatarPlaceHolderİmageView()
        configurationDisplayNameTextFieldLabel()
        configurationUsernameTextFieldLabel()
        configurationBioTextView()
        configurationsubmitButton()
        bindViews()//yayınlananları bağlamak
    }
    @objc private func didTapToDismiss(){
        view.endEditing(true)//klavye kapatmak için
    }
    
    private func bindViews(){
        displayNameTextFieldLabel.addTarget(self, action: #selector(didUpdateDisplayname), for: .editingChanged)
        usernameTextFieldLabel.addTarget(self, action: #selector(didUpdateUsername), for: .editingChanged)
        
        //yayıncıyla ilgilendigimiz için dolar seç.geçerli form oldugunu söyle
        viewModel.$isFormValid.sink { [weak self] buttonState in
            self?.submitButton.isEnabled = buttonState
        }
        .store(in: &subscriptions)
        
        //KAPATMAK İÇİN profiledatafron view modeldeki duruma göre
        viewModel.$isOnboardingFinished.sink { [weak self] success in
            if success{
                self?.dismiss(animated: true)//success ise görntü denetleyicisinden cıkacak
            }
        }

    }
    @objc private func didUpdateDisplayname(){
        viewModel.displayName = displayNameTextFieldLabel.text
        viewModel.validateUserProfileForm()//butonun geçerliliğini açma. kullanıcının 2 karakter girdigi yerde buton devreye girmicek böylelikle
    }
    @objc private func didUpdateUsername(){
        viewModel.username = usernameTextFieldLabel.text
        viewModel.validateUserProfileForm()
    }
    
    
    private func configurationScrollView(){
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func configurationHintLabel(){
        scrollView.addSubview(hintLabel)
        
        NSLayoutConstraint.activate([
            hintLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            hintLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 30)
        ])
    }
    private func configurationAvatarPlaceHolderİmageView(){
        scrollView.addSubview(avatarPlaceholderImageView)
        
        avatarPlaceholderImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToUpload)))
        
        NSLayoutConstraint.activate([
            avatarPlaceholderImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            avatarPlaceholderImageView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor,constant: 30),
            avatarPlaceholderImageView.heightAnchor.constraint(equalToConstant: 120),
            avatarPlaceholderImageView.widthAnchor.constraint(equalToConstant: 120)
        ])

    }
    @objc func didTapToUpload(){
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // burda screenshotlar videolar vs var
        configuration.selectionLimit = 1//foto yükleme limitgi
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self //extension oluşturduk
        present(picker, animated: true)
    }
    
    private func configurationDisplayNameTextFieldLabel(){
        scrollView.addSubview(displayNameTextFieldLabel)
        displayNameTextFieldLabel.delegate = self
        
        NSLayoutConstraint.activate([
            displayNameTextFieldLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            displayNameTextFieldLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            displayNameTextFieldLabel.topAnchor.constraint(equalTo: avatarPlaceholderImageView.bottomAnchor,constant: 40),
            displayNameTextFieldLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configurationUsernameTextFieldLabel(){
        scrollView.addSubview(usernameTextFieldLabel)
        usernameTextFieldLabel.delegate = self //extensionda çagırdık
        
        NSLayoutConstraint.activate([
            usernameTextFieldLabel.leadingAnchor.constraint(equalTo: displayNameTextFieldLabel.leadingAnchor),
            usernameTextFieldLabel.trailingAnchor.constraint(equalTo: displayNameTextFieldLabel.trailingAnchor),
            usernameTextFieldLabel.topAnchor.constraint(equalTo: displayNameTextFieldLabel.bottomAnchor,constant: 20),
            usernameTextFieldLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configurationBioTextView(){
        scrollView.addSubview(bioTextView)
        bioTextView.delegate = self // extensionda çağırıyoruz
        
        NSLayoutConstraint.activate([
            bioTextView.leadingAnchor.constraint(equalTo: displayNameTextFieldLabel.leadingAnchor),
            bioTextView.trailingAnchor.constraint(equalTo: displayNameTextFieldLabel.trailingAnchor),
            bioTextView.topAnchor.constraint(equalTo: usernameTextFieldLabel.bottomAnchor,constant: 20),
            bioTextView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func configurationsubmitButton(){
        scrollView.addSubview(submitButton)
        
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor,constant: -20)
        ])
    }
    @objc private func didTapSubmit(){
        viewModel.uploadAvatar()
    }


}

extension ProfileDataFromViewController:UITextViewDelegate,UITextFieldDelegate{
    //düzenleme kontrol
    func textViewDidBeginEditing(_ textView: UITextView) {
         scrollView.setContentOffset(CGPoint(x: 0, y: textView.frame.origin.y - 100), animated: true)
 
        if textView.textColor == .gray{//metin griyse . girilecek texti label yap ve textini boşalt. BÖYLE DÜZENLEMEYE BAŞLADIGIMIZ ANDA BU İŞLEM GERÇEKLEŞİCEK
            textView.textColor = .label
            textView.text = ""
            
        }
    }
    // DÜZENLEME BİTTİ EGER HER ŞEY SİLİNMİŞ VE BOŞSA GERİ DÖNCEK
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)


        if textView.text.isEmpty{
            textView.text = "Tell the world about yourself"
            textView.textColor = .gray
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //textfieldlara bastıgımızda yukarı kaydırarak yazılanların görünmesini sağlama
        scrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y - 100), animated: true)// y ye yazdıgımız değer üst sınırın nerden baslıcagınıbelirliyor .
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        // metinlerden çıkıldıgında tekrar ekranı başa sarmak için
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    func textViewDidChange(_ textView: UITextView) {
        viewModel.bio = textView.text //textfieldd gibi target atanmıyor burda viewmodeldeki yayıncıları güncelleriz
        viewModel.validateUserProfileForm()
    }
 


    
}

extension ProfileDataFromViewController:PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results{
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self]object , error in
                //objecte atayacagız.önce onu resme çevirmeliyiz
                if let image = object as? UIImage{
                    //güncellemek gerekiyor
                    DispatchQueue.main.async {
                        self?.avatarPlaceholderImageView.image = image
                        self?.viewModel.imageData = image//yayınlanan imageyi bağlamamız gerekiyor.böylece kullanıcının foto seçip seçmedigi takip edilir.
                        self?.viewModel.validateUserProfileForm() // foto yoksa çalısmıcak buton
                        
                        //BURDA ELDE ETTİGİMİZ FOTOYU FİREBASEYE İLETMEK İÇİN STROGE MANAGERE GİTTİK
                    }
                }
            }
        }
    }
    
    
}
