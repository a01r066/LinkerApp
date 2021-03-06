//
//  Advertiser.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/6/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
    let title: String
    let brandName: String
    let posterName: String
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "\n\(brandName)", attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .bold)]))
        return CardViewModel(imageName: posterName, attributedText: attributedText, textAlignment: .center)
    }
}
