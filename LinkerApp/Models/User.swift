//
//  User.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Thanh Minh on 11/3/18.
//  Copyright © 2018 Thanh Minh. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModel {
    
    // defining our properties for our model layer
    var uid: String
    var name: String?
    var age: Int?
    var profession: String?
    var imageURLs: [String]?
    var bio: String?
    var ageRanges: [String : Any]?
    
    init(uid: String, dict: [String:Any]){
        self.uid = uid
        self.name = dict["fullName"] as? String ?? "Fullname"
        self.age = dict["age"] as? Int ?? -1
        self.profession = dict["profession"] as? String ?? "Job Title"
        self.imageURLs = dict["imageURLs"] as? [String] ?? [Constants.DEFAULT_IMAGE_URL]
        self.bio = dict["bio"] as? String ?? "Biography"
        self.ageRanges = dict["ageRanges"] as? [String : Any] ?? ["minAge": 18, "maxAge": 65]
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name ?? "N/A", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        let ageString = (age != nil) ? "\(age!)" : "N/A"
        attributedText.append(NSAttributedString(string: ageString, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))

        let professionString = (profession != nil) ? profession! : "N/A"
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))

        return CardViewModel(imageURLs: imageURLs ?? [""], attributedString: attributedText, textAlignment: .left)
    }
}


