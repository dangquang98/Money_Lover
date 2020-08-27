//
//  SignUp.swift
//  MoneyLover
//
//  Created by Interns on 8/21/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

protocol SignUpDelegate: class {
	func signUpTapBack(_ signUpTapBack: SignUp)
}
protocol ToSignInDelegate: class {
	func signInTapGo(_ signInTapGo: SignUp)
}
protocol EnableSignUpDelegate: class {
	func signUpTapEnable(_ signUpTapEnable: SignUp)
}

class SignUp: BaseView {
	@IBOutlet weak var signUpLabel: UILabel!
	@IBOutlet weak var firstNameTextField: UITextField!
	@IBOutlet weak var lastNameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var confirmPasswordTextField: UITextField!
	@IBOutlet weak var eyeBtn1: UIButton!
	@IBOutlet weak var eyeBtn2: UIButton!
	@IBOutlet weak var signInBtn: UIButton!
	@IBOutlet weak var signUpBtn: UIButton!
	@IBOutlet weak var backBtn: UIButton!
	weak var delegate: SignUpDelegate?
	weak var delegateToSI: ToSignInDelegate?
	weak var delegateIsEnableSU: EnableSignUpDelegate?

	@IBAction func signInTap(_ sender: UIButton) {
		delegateToSI?.signInTapGo(self)
	}
	@IBAction func backTap(_ sender: UIButton) {
		delegate?.signUpTapBack(self)
	}
	@IBAction func eyeTap1(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
		if sender.isSelected {
			self.passwordTextField.isSecureTextEntry = false
			eyeBtn1.setImage(UIImage(named: "eye_close"), for: .normal)
		} else {
			self.passwordTextField.isSecureTextEntry = true
			eyeBtn1.setImage(UIImage(named: "eye_open"), for: .normal)
		}
	}
	@IBAction func eyeTap2(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
		if sender.isSelected {
			self.confirmPasswordTextField.isSecureTextEntry = false
			eyeBtn2.setImage(UIImage(named: "eye_close"), for: .normal)
		} else {
			self.confirmPasswordTextField.isSecureTextEntry = true
			eyeBtn2.setImage(UIImage(named: "eye_open"), for: .normal)
		}
	}
	@IBAction func btnSaveTap(_ sender: UIButton) {
		delegateIsEnableSU?.signUpTapEnable(self)
	}
}
