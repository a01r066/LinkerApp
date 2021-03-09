//
//  ViewController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Brian Voong on 10/31/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
    
//    let cardViewModels: [CardViewModel] = {
//        let producers = [
//            User(name: "Kelly", age: 23, profession: "Music DJ", imageNames: ["kelly1", "kelly2", "kelly3"]),
//            Advertiser(title: "Slide Out Menu", brandName: "Lets Build That App", posterPhotoName: "slide_out_menu_poster"),
//            User(name: "Jane", age: 18, profession: "Teacher", imageNames: ["jane1", "jane2", "jane3"])
//        ] as [ProducesCardViewModel]
//
//        let viewModels = producers.map({return $0.toCardViewModel()})
//        return viewModels
//    }()
    
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        setupLayout()
        setupFirestoreCardUsers()
        fetchUserFromFirestore()
    }
    
//    var lastFetchedUser: User?
//    var lastSnapshot: QueryDocumentSnapshot?
    fileprivate func fetchUserFromFirestore(){
//        let query = Firestore.firestore().collection("users").whereField("profession", isEqualTo: "Teacher")
//        let query = Firestore.firestore().collection("users").whereField("age", isLessThan: 36).whereField("age", isGreaterThan: 23)
//        query.getDocuments{ (snapshot, err) in
//            if let err = err {
//                print("Failed to fetch user: ", err)
//                return
//            }
//
//            snapshot?.documents.forEach({ (docSnapshot) in
//                print(docSnapshot)
//                let userDictionary = docSnapshot.data()
//                let uid = docSnapshot.documentID
//                let user = User(uid: uid, dict: userDictionary)
//                self.lastFetchedUser = user
//                self.setupCardFromUser(user: user)
////                self.cardViewModels.append(user.toCardViewModel())
//            })
////            self.setupFirestoreCardUsers()
//        }
        
        // // Construct query for first 2 users, ordered by fullName
        let db = Firestore.firestore()
        let first = db.collection("users").order(by: "fullName").limit(to: 2)
        
        first.addSnapshotListener { (firstSnapshot, err) in
            if let err = err {
                print("Error retreving users", err.localizedDescription)
                return
            }
            
            guard let lastSnapshot = firstSnapshot?.documents.last else {
                // The collection is empty.
                return
            }
            
            // Construct a new query starting after this document,
            // retrieving the next 2
            let next = db.collection("users").order(by: "fullName").start(afterDocument: lastSnapshot)
            
            // Use the query for pagination.
            // ...
            next.getDocuments { (snapshot, err) in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                snapshot?.documents.forEach({ (docSnapshot) in
//                    print(docSnapshot)
                    let userDictionary = docSnapshot.data()
                    let uid = docSnapshot.documentID
                    let user = User(uid: uid, dict: userDictionary)
//                    self.lastFetchedUser = user
                    self.setupCardFromUser(user: user)
                })
            }
        }
    }
    
    fileprivate func setupCardFromUser(user: User){
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    @objc func handleSettings() {
        print("Show registration page")
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
    }
    
    fileprivate func setupFirestoreCardUsers() {
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }

    // MARK:- Fileprivate
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
        
        buttonsStackView.delegate = self
    }
}

extension HomeController: HomeBottomControlsStackViewDelegate {
    func handleRefresh() {
        print("refresh")
        fetchUserFromFirestore()
    }
}

