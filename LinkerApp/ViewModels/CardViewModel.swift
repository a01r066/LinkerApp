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

struct CardViewModel {
    let imageName: String
    let attributedText: NSAttributedString
    let textAlignment: NSTextAlignment
}
