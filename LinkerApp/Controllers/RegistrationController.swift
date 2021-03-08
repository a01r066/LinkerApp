//
//  RegistrationController.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/7/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegistrationController: UIViewController {
    let selectPhotoBtn: CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = UIColor.white
        btn.setButtonStyle(title: "Select Photo", titleColor: UIColor.black, cornerRadius: 16)
        btn.heightAnchor.constraint(equalToConstant: 275).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 275).isActive = true
        btn.imageView?.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return btn
    }()
    
    let nameTf: CustomTextfield = {
        let tf = CustomTextfield(padding: 20)
        tf.backgroundColor = UIColor.white
        tf.setTextfieldStyle(placeHolder: "Fullname")
//        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
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
//        tf.isSecureTextEntry = true
        return tf
    }()
    
    let registerbtn: CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = UIColor.lightGray
//        btn.isEnabled = false
        btn.setButtonStyle(title: "Register", titleColor: UIColor.gray, cornerRadius: 25)
        btn.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleSelectPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleRegister(){
        print("Click")
        guard let email = emailTf.text else { return }
        guard let password = passwordTf.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print(err)
                self.showError(err: err)
                return
            }
            print("User created!")
        }
    }
    
    func showError(err: Error){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Error occur!"
        hud.detailTextLabel.text = "Error desc: \(err.localizedDescription)"
        hud.show(in: view)
        hud.dismiss(afterDelay: 3)
    }
    
    let gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupGradientLayer()
        setupViews()
        keyboardNotificationObservers()
        setupTapGesture()
        setupRegistrationViewModelObserver()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self) // avoid retain cycle
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if(self.traitCollection.verticalSizeClass == .compact){
            overallStackView.axis = .horizontal
        } else {
            overallStackView.axis = .vertical
        }
    }
    
    func setupRegistrationViewModelObserver(){
        registrationViewModel.isFormValidObserver = {[unowned self] (isFormValid) in
            print("isFormValid: \(isFormValid)")
            self.registerbtn.isEnabled = isFormValid
            if(isFormValid){
                self.registerbtn.backgroundColor = UIColor.purple
                self.registerbtn.setTitleColor(UIColor.white, for: .normal)
            } else {
                self.registerbtn.backgroundColor = UIColor.lightGray
                self.registerbtn.setTitleColor(UIColor.gray, for: .normal)
            }
        }
        
//        registrationViewModel.imageObserver = {(img) in
//            self.selectPhotoBtn.setImage(img, for: .normal)
//        }
        registrationViewModel.bindableImage.bind { [unowned self] (img) in
            self.selectPhotoBtn.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    var registrationViewModel = RegistrationViewModel()
    @objc func handleTextChanged(textField: UITextField){
        if(textField == nameTf){
            registrationViewModel.fullName = textField.text
        } else if(textField == emailTf){
            registrationViewModel.email = textField.text
        } else if(textField == passwordTf){
            registrationViewModel.password = textField.text
        }
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
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
//        print(bottomSpace)
        let differentSpace = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -differentSpace - 8)
    }
    
    func setupGradientLayer(){
        let topColor = #colorLiteral(red: 0.9197903275, green: 0.3539565504, blue: 0.3639886975, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8983729482, green: 0.266651392, blue: 0.4615507126, alpha: 1)
        gradientLayer.colors =  [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            nameTf,
            emailTf,
            passwordTf,
            registerbtn
        ])
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .fillEqually
        return sv
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        selectPhotoBtn,
        verticalStackView
    ])
    
    func setupViews(){
        overallStackView.axis = .vertical
        overallStackView.spacing = 8
        view.addSubview(overallStackView)
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
//        registrationViewModel.image = image
        registrationViewModel.bindableImage.value = image
        dismiss(animated: true, completion: nil)
    }
}
