//
//  CustomButton.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/7/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

//
//  CustomButton.swift
//  Hang Sat Gia Si
//
//  Created by Thanh Minh on 2/21/18.
//  Copyright © 2018 Thanh Minh. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 50)
    }
    
    func setButtonStyle(title: String?, titleColor: UIColor?, cornerRadius: CGFloat?){
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.layer.cornerRadius = cornerRadius!
        self.showsTouchWhenHighlighted = true
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
}

