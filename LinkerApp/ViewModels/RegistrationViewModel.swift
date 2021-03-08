//
//  RegistrationViewModel.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Brian Voong on 11/14/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            
            if let err = err {
                completion(err)
                return
            }
            
            print("Successfully registered user:", res?.user.uid ?? "")
            self.saveImageToFirebase(completion: completion)
        }
    }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()){
        // Only upload images to Firebase Storage once you are authorized
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil, completion: { (_, err) in
            
            if let err = err {
                completion(err)
                return // bail
            }
            
            print("Finished uploading image to storage")
            ref.downloadURL(completion: { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                
                self.bindableIsRegistering.value = false
                print("Download url of our image is:", url?.absoluteString ?? "")
                // store the download url into Firestore next lesson
                let imageURL = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageURL: imageURL, completion: completion)
            })
        })
    }
    
    fileprivate func saveInfoToFirestore(imageURL: String, completion: @escaping (Error?) -> ()){
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = [
            "fullName": fullName ?? "",
            "imageURL": imageURL
        ]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if let err = err {
                completion(err)
                return
            }
            print("User info saved!")
        }
    }
}
