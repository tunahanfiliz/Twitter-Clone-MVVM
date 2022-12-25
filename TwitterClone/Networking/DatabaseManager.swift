//
//  DatabaseManager.swift
//  TwitterClone
//
//  Created by Ios Developer on 18.12.2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Combine

class DatabaseManager{
    static let shared = DatabaseManager()
    
    let db = Firestore.firestore()
    let usersPath:String = "users"
    
    
    func collectionUsers(add user:User)-> AnyPublisher<Bool,Error>{
        let twitterUser = TwitterUser(from: user)
        return db.collection(usersPath).document(twitterUser.id).setData(from: twitterUser)
            .map { _ in
                return true
            }//bool olması gerektiginden .map yapıp dönüştürme yaparsak hata gider
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(retreive id:String) -> AnyPublisher<TwitterUser,Error>{  // giriş yapan kullanıcıyı almak için oluşturulan fonk. homeviewmodel de çagırıyoruz. sonra homeviewde wilwilapperda alınır
        db.collection(usersPath).document(id).getDocument()
            .tryMap{
                try $0.data(as:TwitterUser.self)
            }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(updateFields:[String:Any],for id:String) -> AnyPublisher<Bool,Error>{
        db.collection(usersPath).document(id).updateData(updateFields)
            .map { _ in
                true
            }.eraseToAnyPublisher()
    }
}
