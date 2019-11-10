//
//  LoginView.swift
//  Mobe
//
//  Created by Igor Soares on 07/07/19.
//  Copyright © 2019 Igor Soares. All rights reserved.
//

import UIKit

class LoginView: UIView {
  @IBOutlet var contentView: LoginView!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var createAccountButton: UIButton!
  @IBOutlet weak var forgotPassswordButton: UIButton!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    Bundle.main.loadNibNamed("Login", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    setupViews()
  }
  
  func setupViews() {
    
    emailTextField.setup(placeholder: "Digite seu e-mail")
    passwordTextField.setup(placeholder: "Digite a sua senha")
  
  }
  
  @IBAction func clickForgotPasswordButton(_ sender: Any) {
  
  }
  
  @IBAction func clickLoginButton(_ sender: Any) {
  
  }
  
  @IBAction func clickCreateAccountButton(_ sender: Any) {
  
  }
}
