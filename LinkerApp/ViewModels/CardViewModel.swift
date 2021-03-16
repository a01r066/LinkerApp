//
//  CardViewModel.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Brian Voong on 11/5/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

// View Model is supposed represent the State of our View
class CardViewModel {
    // we'll define the properties that are view will display/render out
    let imageURLs: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageURLs: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageURLs = imageURLs
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageURLString = imageURLs[imageIndex]
            imageIndexObserver?(imageIndex, imageURLString)
        }
    }
    
    // Reactive Programming
    var imageIndexObserver: ((Int, String?) -> ())?
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageURLs.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}

// what exactly do we do with this card view model thing???

