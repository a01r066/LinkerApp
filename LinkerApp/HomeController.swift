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
    let cardsDeskView = UIView()
    let bottomBarStackView = BottomBarStackView()
    
    let cardViewModels: [CardViewModel] = {
        let producers = [
            User(name: "Kelly", age: 23, profession: "Fashion Model", imageName: "lady4c"),
            User(name: "Shally", age: 25, profession: "Designer", imageName: "lady5c"),
            Advertiser(title: "Slide Out Menu", brandName: "Let's Build That App", posterName: "slide_out_menu_poster")
        ] as [ProducesCardViewModel]
        let viewModels = producers.map({return $0.toCardViewModel()})
        return viewModels
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDummyCards()
    }
    
    
    //MARK:- fileprivate
    fileprivate func setupDummyCards(){
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            
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

