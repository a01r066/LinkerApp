//
//  SettingTextField.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/14/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit

class SettingTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 44)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
