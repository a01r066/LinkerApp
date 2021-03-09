//
//  ViewController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Brian Voong on 10/31/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

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
    var users = [User]()
    var lastDocumentSnapshot: DocumentSnapshot!
    var fetchingMore = false
    let hud = JGProgressHUD(style: .dark)
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
        hud.detailTextLabel.text = "Fetching users..."
        hud.show(in: view)
        
        fetchingMore = true
        var query: Query!
        let db = Firestore.firestore()
        
        if users.isEmpty {
            query = db.collection("users").order(by: "fullName").limit(to: 2)
            print("First 2 users loaded")
        } else {
            query = db.collection("users").order(by: "fullName").start(afterDocument: lastDocumentSnapshot).limit(to: 2)
            print("Next 2 users loaded")
        }
        
        query.getDocuments { (snapshot, err) in
            if let err = err {
                print("\(err.localizedDescription)")
            } else if snapshot!.isEmpty {
                self.fetchingMore = false
                return
            } else {
                let newUsers = snapshot!.documents.compactMap({User(uid: $0.documentID, dict: $0.data())})
                
                // display user
                newUsers.forEach { (user) in
                    self.setupCardFromUser(user: user)
                }
                
                self.users.append(contentsOf: newUsers)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//                    self.tableView.reloadData()
                    self.fetchingMore = false
                })

                self.lastDocumentSnapshot = snapshot!.documents.last
            }
            self.hud.dismiss(animated: true)
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
        if !fetchingMore {
            fetchUserFromFirestore()
        }
    }
}

