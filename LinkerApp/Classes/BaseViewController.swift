//
//  BaseViewController.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/14/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit
import JGProgressHUD
import SDWebImage

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showHUDWithInfo(title: String?, subTitle: String){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = title
        hud.detailTextLabel.text = subTitle
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3000)
    }
    
    func showHUDWithError(title: String, error: Error){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = title
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3000)
    }
}
