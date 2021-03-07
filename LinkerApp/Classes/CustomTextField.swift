//
//  CustomTextField.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/7/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit

class CustomTextfield: UITextField {
    let padding: CGFloat
    
    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    func setTextfieldStyle(placeHolder: String){
        self.placeholder = placeHolder
    }
}
