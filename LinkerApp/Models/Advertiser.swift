//
//  Advertiser.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Thanh Minh on 11/6/18.
//  Copyright © 2018 Thanh Minh. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
    let title: String
    let brandName: String
    let posterPhotoName: String
    
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        
        attributedString.append(NSAttributedString(string: "\n" + brandName, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        
        return CardViewModel(imageURLs: [posterPhotoName], attributedString: attributedString, textAlignment: .center)
    }
}


