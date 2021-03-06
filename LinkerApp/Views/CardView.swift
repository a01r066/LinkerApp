//
//  CardView.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/6/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit

class CardView: UIView {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    
    var cardViewModel: CardViewModel! {
        didSet{
            imageView.image = UIImage(named: cardViewModel.imageName)
            informationLabel.attributedText = cardViewModel.attributedText
            informationLabel.textAlignment = cardViewModel.textAlignment
        }
    }
    
    let informationLabel: UILabel = {
       let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.numberOfLines = 0
        return lbl
    }()
    
    // configurations
    fileprivate let threshold: CGFloat = 100

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupPanGesture()
        
    }
    
    fileprivate func setupPanGesture(){
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(gesture)
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translate = gesture.translation(in: nil)
        let degrees = translate.x/20
        let angle = degrees * .pi/180
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translate.x, y: translate.y)
        self.transform = CGAffineTransform(translationX: translate.x, y: translate.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let translateDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                self.frame = CGRect(x: 1000 * translateDirection, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
        }) {(_ ) in
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        layer.cornerRadius = 10
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
    }
    
}
