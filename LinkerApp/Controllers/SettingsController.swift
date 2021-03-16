//
//  SettingsController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Brian Voong on 11/19/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit
import JGProgressHUD
import SDWebImage
import Firebase

class CustomImagePickerController: UIImagePickerController {
    
    var imageButton: UIButton?
    
}

protocol SettingsControllerDelegate {
    func handleReload(user: User)
}

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var delegate: SettingsControllerDelegate?
    
    var user: User? {
        didSet{
            self.tableView.reloadData()
        }
    }
    let settingsViewModel = SettingsViewModel()
    
    // instance properties
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    @objc func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    var imageURLs = [String]()
    var minAge = 18
    var maxAge = 65
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        // how do i set the image on my buttons when I select a photo?
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
//        print("ButtonTag: ", imageButton?.tag ?? -1)
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        // save image to firestore
        settingsViewModel.saveImageToFirebase(image: selectedImage ?? UIImage()) { (err, imageURL) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            self.imageURLs[(imageButton?.tag ?? 0) - 1] = imageURL ?? Constants.DEFAULT_IMAGE_URL
        }
        dismiss(animated: true)
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        setupSettingsViewModelObserver()
        setImageButtonsTag()
    }
    
    func setImageButtonsTag(){
        image1Button.tag = 1
        image2Button.tag  = 2
        image3Button.tag = 3
    }
    
    fileprivate func setupSettingsViewModelObserver(){
        settingsViewModel.fetchUser()
        
        settingsViewModel.bindableUser.bind { (user) in
            self.user = user
            self.imageURLs = user?.imageURLs ?? [Constants.DEFAULT_IMAGE_URL]
            self.settingsViewModel.loadUserPhotos(user: user)
        }
        
        settingsViewModel.bindableImageURLs.bind { (imageURLs) in
            let imageButtons = [
                self.image1Button,
                self.image2Button,
                self.image3Button
            ]
            for index in 0..<imageURLs!.count {
                let url = URL(string: imageURLs![index])
                SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                    imageButtons[index].setImage(image!.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
        }
    }
        
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    @objc func handleSave(){
        settingsViewModel.imageURLs = imageURLs
        settingsViewModel.handleSave(user: user) { (err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
        }
        self.dismiss(animated: true) {
            guard let user = self.user else { return }
            self.delegate?.handleReload(user: user)
        }
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    // lazy var --> header load instantiate after image buttons
    lazy var header: UIView = {
        let v = UIView()
        v.addSubview(image1Button)
        let padding: CGFloat = 16
        image1Button.anchor(top: v.topAnchor, leading: v.leadingAnchor, bottom: v.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: v.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        v.addSubview(stackView)
        stackView.anchor(top: v.topAnchor, leading: image1Button.trailingAnchor, bottom: v.bottomAnchor, trailing: v.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return v
    }()
    
    let slideHeaderView = UIView()
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 0){
            return header
        } else if(section == 5){
            let title = HeaderLabel()
            title.text = "Seeking Age Range"
            
            return title
        } else {
            let headerLabel = HeaderLabel()
            headerLabel.text = settingsViewModel.getHeaderTitle(section: section)
            return headerLabel
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 5){
            let sliderTvCell = SliderTvCell(style: .default, reuseIdentifier: nil)
            sliderTvCell.delegate = self
            sliderTvCell.ageRanges = user?.ageRanges ?? [:]
            sliderTvCell.setAgeRanges()
            return sliderTvCell
        } else {
            let cell = SettingTvCell()
            //        cell.textField.placeholder = getHeaderTitle(section: indexPath.section)
            cell.textField.text = settingsViewModel.getTextField(section: indexPath.section, user: user)
            cell.textField.tag = indexPath.section
            cell.textField.addTarget(self, action: #selector(handleTextFieldChanged(_:)), for: .editingChanged)
            return cell
        }
    }
    
    @objc func handleTextFieldChanged(_ textField: UITextField){
//        print("textField.text: ", textField.tag)
        switch textField.tag {
        case 1:
            user?.name = textField.text
        case 2:
            user?.profession = textField.text
        case 3:
            user?.age = Int(textField.text ?? "0")
        default:
            user?.bio = textField.text
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
        
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 300 : 44
    }
}

extension SettingsController: SliderTvCellDelegate {
    func didHandleSlideChange(slider: UISlider) {
        if(slider.tag == 1){
            minAge = Int(slider.value)
        } else {
            maxAge = Int(slider.value)
        }
        let ageRanges = [
            "minAge" : minAge,
            "maxAge" : maxAge
        ]
        settingsViewModel.ageRanges = ageRanges
    }
}
