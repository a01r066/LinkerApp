//
//  BottomBarStackView.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/6/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit

class BottomBarStackView: UIStackView {

    let refreshBtn = UIButton(type: .system)
    let removeBtn = UIButton(type: .system)
    let starBtn = UIButton(type: .system)
    let likeBtn = UIButton(type: .system)
    let sendBtn = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        refreshBtn.setImage(#imageLiteral(resourceName: "refresh_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        removeBtn.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        starBtn.setImage(#imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        likeBtn.setImage(#imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        sendBtn.setImage(#imageLiteral(resourceName: "boost_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [refreshBtn, removeBtn, starBtn, likeBtn, sendBtn].forEach { (button) in
            addArrangedSubview(button)
        }
        
        distribution = .fillEqually
        axis = .horizontal
        heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
