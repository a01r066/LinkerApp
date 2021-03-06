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
    let barsStackView = UIStackView()
    let gradientLayer = CAGradientLayer()
    let informationLabel: UILabel = {
       let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.numberOfLines = 0
        return lbl
    }()
    
    // configurations
    fileprivate let threshold: CGFloat = 100
    var imageIndex = 0
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    var cardViewModel: CardViewModel! {
        didSet{
            let imageName = cardViewModel.imageNames.first ?? ""
            imageView.image = UIImage(named: imageName)
            informationLabel.attributedText = cardViewModel.attributedText
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageNames.count).forEach { (_ ) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = UIColor.white
            setupImageIndexObserver()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupPanGesture()
        setupTapGesture()
    }
    
    func setupImageIndexObserver(){
        cardViewModel.imageIndexObserver = { [weak self] (index, image) in
            self?.imageView.image = image
            self?.barsStackView.arrangedSubviews.forEach({ (v) in
                v.backgroundColor = UIColor(white: 0, alpha: 0.1)
            })
            self?.barsStackView.arrangedSubviews[index].backgroundColor = UIColor.white
        }
    }
    
    func setupTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer){
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        if shouldAdvanceNextPhoto {
            cardViewModel.nextPhoto()
        } else {
            cardViewModel.previousPhoto()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    fileprivate func setupViews() {
        layer.cornerRadius = 10
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        setupBarsStackView()
        
        setupGradientLayer()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
    }
    
    func setupGradientLayer(){
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    func setupBarsStackView(){
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
    }
    
}
