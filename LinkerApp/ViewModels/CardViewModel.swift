//
//  CardViewModel.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/6/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    let imageNames: [String]
    let attributedText: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedText: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedText = attributedText
        self.textAlignment = textAlignment
    }
    
    fileprivate var imageIndex = 0 {
        didSet{
            let imageName = imageNames[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, image)
        }
    }
    var imageIndexObserver: ((Int, UIImage?) -> ())?
    
    func nextPhoto(){
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    
    func previousPhoto(){
        imageIndex = max(0, imageIndex - 1)
    }
}
