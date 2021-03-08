//
//  RegistrationViewModel.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/7/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit

struct RegistrationViewModel {
//    var image: UIImage? {
//        didSet{
//            imageObserver?(image)
//        }
//    }
//    var imageObserver: ((UIImage?)->())?
    
    let bindableImage = Bindable<UIImage>()
    
    var fullName: String? {
        didSet{
            checkFormIsValid()
        }
    }
    var email: String? {
        didSet{
            checkFormIsValid()
        }
    }
    var password: String? { didSet { checkFormIsValid() }}
    
    var isFormValidObserver: ((Bool) -> ())?
    
    func checkFormIsValid(){
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
}
