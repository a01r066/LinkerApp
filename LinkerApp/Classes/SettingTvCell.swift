//
//  SettingTvCell.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/14/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit

class SettingTvCell: UITableViewCell {
    let textField: SettingTextField = {
        let tf = SettingTextField()
        tf.placeholder = "Enter text"
        return tf
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
