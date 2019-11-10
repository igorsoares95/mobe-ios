//
//  UITextField.swift
//  Mobe
//
//  Created by Igor Soares on 07/07/19.
//  Copyright © 2019 Igor Soares. All rights reserved.
//

import UIKit

extension UITextField {
  func setup(placeholder: String) {
    attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: .white as UIColor])
    borderStyle = .none
    layer.borderWidth = 2
    layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).cgColor
    let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
    let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
    self.leftView = leftView
    leftViewMode = .always
    self.rightView = rightView
    rightViewMode = .always
  }
}
