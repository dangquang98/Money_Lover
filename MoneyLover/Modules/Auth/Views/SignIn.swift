//
//  SignIn.swift
//  MoneyLover
//
//  Created by Interns on 8/21/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

class SignIn: BaseView {

	@IBOutlet weak var signInLabel: UILabel!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var eyeBtn: UIButton!
	@IBOutlet weak var signInBtn: UIButton!
	@IBOutlet weak var signUpBtn: UIButton!

	@IBAction func eyeTap(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
		if sender.isSelected {
			self.passwordTextField.isSecureTextEntry = false
			eyeBtn.setImage(UIImage(named: "eye_close"), for: .normal)
		} else {
			self.passwordTextField.isSecureTextEntry = true
			eyeBtn.setImage(UIImage(named: "eye_open"), for: .normal)
		}
	}
}
