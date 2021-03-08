//
//  Bindable.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/8/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit

class Bindable<T> {
    var value: T? {
        didSet{
            observer?(value)
        }
    }
    var observer: ((T?)->())?
    
    func bind(observer: @escaping (T?)->()){
        self.observer = observer
    }
}

