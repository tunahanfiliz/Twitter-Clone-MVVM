//
//  RegisterViewModel.swift
//  TwitterClone
//
//  Created by Ios Developer on 15.12.2022.
//

import Foundation
import Firebase
import Combine

final class AuthenticationViewModel:ObservableObject{
    
    @Published var email:String?
    @Published var password:String?
    @Published var isAuthenticationFormValid:Bool = false // geçersiz kullanıcıysa kaydolma dügmeye dokundurtmaz
    @Published var user:User? // en altta fonksiyonda user doldurulur.
    @Published var error:String?
    private var subscriptions:Set<AnyCancellable> = []
    
    func validateAuthenticationForm(){
        guard let email = email ,
            let password = password else{
            isAuthenticationFormValid = false
            return
        }
        isAuthenticationFormValid = isValidEmail(email) && password.count >= 8
        
    }
    func isValidEmail(_ email: String) -> Bool { //e posta dogrulama ifadesi
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func createUser(){ //createUser(with email:String,password:String) şeklinde yapmadık çünkü @publishedde var zaten değerler direkt email yazdık.çünkü doğrulama (valid)bağlama işlevlerinde kontrol edildi
        
        guard let email = email,
              let password = password else{return}
        AuthManager.shared.registerUser(with: email, password: password)//abone olup silme senkronizasyon işlemleri için sink
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
            })
            .sink { [weak self] completion in
                //tüm caseleri ele almak yerine direkt failure için
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
        
                
            } receiveValue: { [weak self] user in
                self?.createRecord(for: user)
            }
            .store(in: &subscriptions)

    }
    
    func createRecord(for user:User){
        DatabaseManager.shared.collectionUsers(add: user)
            .sink{[weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { state in
                print("adding user record to database:\(state)")
            }.store(in: &subscriptions)
    }
    
    func loginUser(){ //createUser(with email:String,password:String) şeklinde yapmadık çünkü @publishedde var zaten değerler direkt email yazdık.çünkü doğrulama (valid)bağlama işlevlerinde kontrol edildi
        
        guard let email = email,
              let password = password else{return}
        AuthManager.shared.loginUser(with: email, password: password)//abone olup silme senkronizasyon işlemleri için sink
            .sink { [weak self] completion in
                //tüm caseleri ele almak yerine direkt failure için
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
        
            } receiveValue: { [weak self] user in
                self?.user = user //burda useri dolduruyoruz
            }
            .store(in: &subscriptions)

    }
}
