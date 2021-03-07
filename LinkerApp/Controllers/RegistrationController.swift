//
//  RegistrationController.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/7/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
    let selectPhotoBtn: CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = UIColor.white
        btn.setButtonStyle(title: "Select Photo", titleColor: UIColor.black, cornerRadius: 16)
        btn.heightAnchor.constraint(equalToConstant: 275).isActive = true
        return btn
    }()
    
    let nameTf: CustomTextfield = {
        let tf = CustomTextfield(padding: 20)
        tf.backgroundColor = UIColor.white
        tf.setTextfieldStyle(placeHolder: "Fullname")
//        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return tf
    }()
    
    let emailTf: CustomTextfield = {
        let tf = CustomTextfield(padding: 20)
        tf.backgroundColor = UIColor.white
        tf.setTextfieldStyle(placeHolder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    let passwordTf: UITextField = {
        let tf = CustomTextfield(padding: 20)
        tf.backgroundColor = UIColor.white
        tf.setTextfieldStyle(placeHolder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let registerbtn: CustomButton = {
        let btn = CustomButton()
        btn.setButtonStyle(title: "Register", titleColor: UIColor.white, cornerRadius: 25)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupGradientLayer()
        setupViews()
        keyboardNotificationObservers()
        setupTapGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self) // avoid retain cycle
    }
    
    func setupTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleDismissKeyboard(){
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    func keyboardNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboarddHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func handleKeyboarddHide(notification: Notification){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc func handleKeyboardShow(notification: Notification){
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
//        print(keyboardFrame)
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
//        print(bottomSpace)
        let differentSpace = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -differentSpace - 8)
    }
    
    func setupGradientLayer(){
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.9197903275, green: 0.3539565504, blue: 0.3639886975, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8983729482, green: 0.266651392, blue: 0.4615507126, alpha: 1)
        gradientLayer.colors =  [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [
        selectPhotoBtn,
        nameTf,
        emailTf,
        passwordTf,
        registerbtn
    ])
    
    func setupViews(){
        stackView.axis = .vertical
        stackView.spacing = 8
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }

}
