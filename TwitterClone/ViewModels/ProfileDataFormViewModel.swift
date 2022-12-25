//
//  ProfileDataFormViewModel.swift
//  TwitterClone
//
//  Created by Ios Developer on 18.12.2022.
//

import Foundation
import UIKit
import Combine
import FirebaseAuth
import FirebaseStorage

final class ProfileDataFormViewModel:ObservableObject{
    
    private var subscriptions:Set<AnyCancellable> = []
    @Published var displayName:String?
    @Published var username:String?
    @Published var bio:String?
    @Published var avatarPath:String?
    @Published var imageData: UIImage?
    @Published var isFormValid:Bool = false
    @Published var error:String = ""
    @Published var isOnboardingFinished:Bool = false
    
    
    func validateUserProfileForm(){
        guard let displayName = displayName,
              displayName.count > 2,
              let username = username,
              username.count > 2,
              let bio = bio,
              bio.count > 2,
              imageData != nil else{
            isFormValid = false
            return
        }
        isFormValid = true
    }
    
    func uploadAvatar(){ //avatarı firebaseya depolama işlem
        
        let randomID = UUID().uuidString
        guard let imageData = imageData?.jpegData(compressionQuality: 0.5) else {return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg" //meta veri içerik tipini yazıcaz
        
        StorageManager.shared.uploadProfilePhoto(with: randomID, image: imageData, metaData: metaData) //resmi yükleyerek receivevalue kısmında urlyi getirecegiz
            .flatMap({ metaData in //meta verileri alınacak
                StorageManager.shared.getDownloadURL(for: metaData.path)
            })
            .sink { [weak self] completion in
                switch completion{
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.error = error.localizedDescription
                case .finished: //her seyi yukledikten sonra firebaseye verileri göndermek için aşağıda yeni bi işlev oluşturup burada çagırdık
                    self?.updateUserData()//aşagıda getirelen url yi kullanarak avatarımızı ve kullanııcı verilerini günccellenerek bitiricez
                }
            } receiveValue: { [weak self]url in
                self?.avatarPath = url.absoluteString//url nesnesinden dönüştürme bu şekil yapılır
            }.store(in: &subscriptions)


    }
    
    private func updateUserData(){//database managere git
        guard let displayName,
              let username,
              let bio,
              let avatarPath,
              let id = Auth.auth().currentUser?.uid else {return}
        
        let updateFields:[String:Any] = [
            "displayName":displayName,
            "username":username,
            "bio":bio,
            "avatarPath":avatarPath,
            "isUserOnboarded":true
        ]//isuseronboarded değişkenini değiştirmemiz lazım (model kısmında bulunuyor)
        
        //veritabanına(database) ye iletmek için
        DatabaseManager.shared.collectionUsers(updateFields: updateFields, for: id)
            .sink { [weak self]completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                    self?.error = error.localizedDescription
                }
                //AŞAĞIDAKİ AÇIKLAMA ÖNEMLİ
            } receiveValue: { [weak self] onboardingState in//görünüm modelimize bu eklemenin bittigini bildiricez (isonboardingfinished) ardından profiledata form view controllerdeki BINDVIEWS a gidicez
                self?.isOnboardingFinished = onboardingState // data base managerde .map ın içindeki true değerini için burda onboarding staateden bilgiyi aldık
            }
            .store(in: &subscriptions)

    }
}
