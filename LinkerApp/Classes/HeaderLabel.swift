//
//  HeaderLabel.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/14/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit

class HeaderLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    */
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
    

}
