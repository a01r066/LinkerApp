//
//  SettingViewModel.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/14/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class SettingsViewModel {
    var bindableUser = Bindable<User>()
    var bindableImageURLs = Bindable<[String]>()
    var bindableAgeRanges = Bindable<[String:Any]>()
    
    var imageURLs = [String]()
    var ageRanges: [String : Any] = [:]
        
    func fetchUser(){
        guard let user = Auth.auth().currentUser else { return }
        Firestore.firestore().collection("users").document(user.uid).getDocument { (snapshot, _) in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(uid: user.uid, dict: dictionary)
            self.bindableUser.value = user
        }
    }
    
    func getTextField(section: Int, user: User?) -> String {
        var settingTitle = ""
        var ageString = ""
        if let age = user?.age {
            ageString = String(age)
        }
        switch(section){
            case 1: settingTitle = user?.name ?? "Enter name"
            case 2: settingTitle = user?.profession ?? "Enter profession"
            case 3: settingTitle = ageString
            default: settingTitle = user?.bio ?? "Enter bio"
        }
        return settingTitle
    }
    
    func getHeaderTitle(section: Int) -> String {
        var settingTitle = ""
        switch(section){
            case 1: settingTitle = "Name"
            case 2: settingTitle = "Profession"
            case 3: settingTitle = "Age"
            default: settingTitle = "Bio"
        }
        return settingTitle
    }
    
    func loadUserPhotos(user: User?){
        guard let imageURLs = user?.imageURLs else { return }
        self.bindableImageURLs.value = imageURLs
    }
    
    func handleSave(user: User?, completion: @escaping (Error?) -> ()){
        guard let user = user else { return }
        let docData: [String : Any] = [
            "fullName": user.name ?? "",
            "age": user.age ?? "",
            "profession": user.profession ?? "",
            "bio": user.bio ?? "",
//            "imageURL1": user.imageURLs ?? ""
            "imageURLs": imageURLs,
            "ageRanges": ageRanges
            ] as [String : Any]
        
        Firestore.firestore().collection("users").document(user.uid).setData(docData) { (err) in
            if let err = err {
                completion(err)
                return
            }
            print("User updated!")
        }
    }
    
    func saveImageToFirebase(image: UIImage, completion: @escaping (Error?, String?) -> ()){
    // Only upload images to Firebase Storage once you are authorized
    let filename = UUID().uuidString
    let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = image.jpegData(compressionQuality: 0.5) ?? Data()
    ref.putData(imageData, metadata: nil, completion: { (_, err) in
        
        if let err = err {
            completion(err, nil)
            return // bail
        }
        
        print("Finished uploading image to storage")
        ref.downloadURL(completion: { (url, err) in
            if let err = err {
                completion(err, nil)
                return
            }
            
            print("Download url of our image is:", url?.absoluteString ?? "")
            // store the download url into Firestore next lesson
            let imageURL = url?.absoluteString ?? ""
            completion(nil, imageURL)
        })
    })
    }
}
