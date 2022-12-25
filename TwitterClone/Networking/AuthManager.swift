//
//  AuthManager.swift
//  TwitterClone
//
//  Created by Ios Developer on 15.12.2022.
//

import Foundation
import Combine //içe aktarma demek anypublished yazabilmek için
import Firebase
import FirebaseAuthCombineSwift
//singleton class yapıcaz sadece bir değeri surec boyunca tutup işletmesi için

class AuthManager{
    static let shared = AuthManager()
    
    func registerUser(with email:String, password:String) -> AnyPublisher<User,Error>{ // kayıtlı olan tüm kullanıcılara eriştirir
        return Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)//kullanıcı oluşturma sonucunu kullanıcıya eşitliyoruz
            .eraseToAnyPublisher() // yayıncı işlevini herhangi bir yayıncıya silebiliriz bu yüzden geri döndürebiliriz auth un basına return yazdık
    }
    func loginUser(with email:String,password:String)-> AnyPublisher<User,Error>{
        return Auth.auth().signIn(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
}
