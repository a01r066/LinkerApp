//
//  HomeBottomControlsStackView.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Thanh Minh on 11/1/18.
//  Copyright © 2018 Thanh Minh. All rights reserved.
//

import UIKit

protocol HomeBottomControlsStackViewDelegate {
    func handleRefresh()
}

class HomeBottomControlsStackView: UIStackView {
    var delegate: HomeBottomControlsStackViewDelegate?
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let refreshButton = createButton(image: #imageLiteral(resourceName: "refresh_circle"))
    let bypassButton = createButton(image: #imageLiteral(resourceName: "dismiss_circle"))
    let favouriteButton = createButton(image: #imageLiteral(resourceName: "super_like_circle"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "refresh_circle"))
    let sendMessageButton = createButton(image: #imageLiteral(resourceName: "refresh_circle"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        [refreshButton, bypassButton, favouriteButton, likeButton, sendMessageButton].forEach { (button) in
            self.addArrangedSubview(button)
        }
        
        refreshButton.addTarget(self, action: #selector(didHandleRefresh), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didHandleRefresh(){
        delegate?.handleRefresh()
    }
}
