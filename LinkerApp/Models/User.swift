//
//  User.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Brian Voong on 11/3/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModel {
    
    // defining our properties for our model layer
    var uid: String
    var name: String?
    var age: Int?
    var profession: String?
    var imageURL1: String?
    
    init(uid: String, dict: [String:Any]){
        self.uid = uid
        self.name = dict["fullName"] as? String ?? ""
        self.age = dict["age"] as? Int ?? -1
        self.profession = dict["profession"] as? String ?? ""
        self.imageURL1 = dict["imageURL1"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name ?? "N/A", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        let ageString = (age != nil) ? "\(age!)" : "N/A"
        attributedText.append(NSAttributedString(string: ageString, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))

        let professionString = (profession != nil) ? profession! : "N/A"
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))

        return CardViewModel(imageNames: [imageURL1 ?? ""], attributedString: attributedText, textAlignment: .left)
    }
}


