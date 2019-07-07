//
//  LoginViewController.swift
//  Mobe
//
//  Created by Igor Soares on 07/07/19.
//  Copyright © 2019 Igor Soares. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
      super.viewDidLoad()
      self.view = LoginView(frame: view.frame)
      self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
  
}
