//
//  StorageManager.swift
//  TwitterClone
//
//  Created by Ios Developer on 21.12.2022.
//

import Foundation
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage

enum FirestorageError:Error{
    case invalidImageIDError
}

final class StorageManager{
    
    static let shared = StorageManager()
    
    let storage = Storage.storage()
    
    
    func getDownloadURL(for id:String?) -> AnyPublisher<URL,Error>{//rastgele koyulan resmin urlsini getirme
        guard let id = id else{
            return Fail(error: FirestorageError.invalidImageIDError)
                .eraseToAnyPublisher()
        }
        return storage
            .reference()
            .child(id)
            .downloadURL()
            .print()
            .eraseToAnyPublisher()
    }
    
    //rastgele resmi alıyor firebasemize koyuyor
    func uploadProfilePhoto(with randomID:String, image: Data, metaData:StorageMetadata) -> AnyPublisher<StorageMetadata,Error> {
        
        storage
            .reference()
            .child("images/\(randomID).jpg")
            .putData(image,metadata: metaData)
            .print()
            .eraseToAnyPublisher()
    }
}
