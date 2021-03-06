//
//  ViewController.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/5/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    let topNavStackView = TopNavStackView()
    let blueView = UIView()
    let cardsDeskView = UIView()
    let bottomBarStackView = BottomBarStackView()
    
    let users = [
        User(name: "Kelly", age: 23, profession: "Fashion Model", imageName: "lady4c"),
        User(name: "Shally", age: 25, profession: "Designer", imageName: "lady5c")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDummyCards()
    }
    
    
    //MARK:- fileprivate
    fileprivate func setupDummyCards(){
        users.forEach { (user) in
            let cardView = CardView(frame: .zero)
            cardView.setupCardView(user: user)
            
            cardsDeskView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        
    }
    
    // MARK:- fileprivate
    fileprivate func setupViews() {
        // Do any additional setup after loading the view.
        let overallStackView = UIStackView(arrangedSubviews: [topNavStackView, cardsDeskView, bottomBarStackView])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardsDeskView)
    }
    
    


}

