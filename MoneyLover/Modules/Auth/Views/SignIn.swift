//
//  SignIn.swift
//  MoneyLover
//
//  Created by Interns on 8/21/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

protocol SignInDelegate: class {
	func signInTapBack(_ signInTapBack: SignIn)
}
protocol ToSignUpDelegate: class {
	func registerTap(_ registerTap: SignIn)
}
protocol EnableSignInDelegate: class {
	func signInTapEnable(_ signInTapEnable: SignIn)
}

class SignIn: BaseView {

	@IBOutlet weak var signInLabel: UILabel!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var eyeBtn: UIButton!
	@IBOutlet weak var signInBtn: UIButton!
	@IBOutlet weak var registerBtn: UIButton!
	@IBOutlet weak var backBtn: UIButton!
	weak var delegate: SignInDelegate?
	weak var delegateToSU: ToSignUpDelegate?
	weak var delegateIsEnableSI: EnableSignInDelegate?

	@IBAction func backTap(_ sender: UIButton) {
		delegate?.signInTapBack(self)
	}
	@IBAction func registerTap(_ sender: UIButton) {
		delegateToSU?.registerTap(self)
	}
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
	@IBAction func btnOkTap(_ sender: UIButton) {
		delegateIsEnableSI?.signInTapEnable(self)
	}
}
