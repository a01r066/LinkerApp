//
//  TopNavStackView.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/5/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit

class TopNavStackView: UIStackView {

    let profileBtn = UIButton(type: .system)
    let trendingBtn = UIButton(type: .system)
    let messageBtn = UIButton(type: .system)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .equalCentering
        axis = .horizontal
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        trendingBtn.contentMode = .scaleAspectFit
        
        
        profileBtn.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        trendingBtn.setImage(#imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        messageBtn.setImage(#imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [profileBtn, trendingBtn, messageBtn].forEach { (button) in
            addArrangedSubview(button)
        }
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
