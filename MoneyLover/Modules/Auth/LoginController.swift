//
//  LoginController.swift
//  MoneyLover
//
//  Created by Interns on 8/21/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

enum LoginType {
	case signin
	case signup
}

class LoginController: UIViewController {

	@IBOutlet weak var signIn: SignIn!
	@IBOutlet weak var signUp: SignUp!

	var loginType: LoginType = .signin

	override func viewDidLoad() {
        super.viewDidLoad()
		signIn.isHidden = loginType == .signup
		signUp.isHidden = loginType == .signin

		signIn.delegate = self
		signUp.delegate = self

		signUpTextFields.forEach {
			$0.delegate = self
		}
		signInTextFields.forEach {
			$0.delegate = self
		}
		signUp.firstNameTextField.tag = 0
		signIn.emailTextField.tag = 0

		signUp.signUpBtn.isEnabled = false
		signIn.signInBtn.isEnabled = false

		signIn.delegateToSU = self
		signUp.delegateToSI = self

		signUp.delegateIsEnableSU = self
		signIn.delegateIsEnableSI = self
    }
	var signUpTextFields: [UITextField] {
		let signUpTextFields = [
			self.signUp.firstNameTextField!,
			self.signUp.lastNameTextField!,
			self.signUp.emailTextField!,
			self.signUp.passwordTextField!,
			self.signUp.confirmPasswordTextField!
		]
		return signUpTextFields
	}
	var signInTextFields: [UITextField] {
		let signInTextFields = [
			self.signIn.emailTextField!,
			self.signIn.passwordTextField!
		]
		return signInTextFields
	}

	func displayAlert(userMessage: String) {
		// Declare Alert message
		let dialogMessage = UIAlertController(title: "Opps", message: userMessage, preferredStyle: .alert)

		// Create OK button with action handler
		let ok = UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
			print("Ok button tapped")
		})

		dialogMessage.addAction(ok)

		// Present dialog message to user
		self.present(dialogMessage, animated: true, completion: nil)
	}
}

extension LoginController: SignInDelegate, SignUpDelegate {
	func signInTapBack(_ signInTapBack: SignIn) {
		self.dismiss(animated: true, completion: nil)
	}
	func signUpTapBack(_ signUpTapBack: SignUp) {
		self.dismiss(animated: true, completion: nil)
	}
}

extension LoginController: ToSignUpDelegate, ToSignInDelegate {
	func signInTapGo(_ signInTapGo: SignUp) {
		signUp.isHidden = true
		signIn.isHidden = false
	}

	func registerTap(_ registerTap: SignIn) {
		signUp.isHidden = false
		signIn.isHidden = true
	}
}

extension LoginController: EnableSignUpDelegate {
	func signUpTapEnable(_ signUpTapEnable: SignUp) {
		guard let fName = signUp.firstNameTextField.text else { return }
		guard let lName = signUp.lastNameTextField.text else { return }
		guard let email = signUp.emailTextField.text else { return }
		guard let password = signUp.passwordTextField.text else { return }
		guard let confirmPassword = signUp.confirmPasswordTextField.text else { return }
//				if !fName.isEmpty || !lName.isEmpty || !email.isEmpty || !password.isEmpty || !confirmPassword.isEmpty {
//					signUp.signUpBtn.isEnabled = false
//				} else {
//					signUp.signUpBtn.isEnabled = true
//				}
		if email.checkIfEmailIsValid() == false {
			displayAlert(userMessage: "Please enter valid email")
		}
		if password.checkIfPasswordIsValid() == false {
			displayAlert(userMessage: "Please enter valid password")
		}
		if password != confirmPassword {
			displayAlert(userMessage: "Passwords do not match")
			return
		}
		let signup = SignUpModel(firstName: fName, lastName: lName, email: email, password: password)
		APIManager.shareInstance.callingSignUpAPI(signup: signup) {[weak self] (user, errStr) in
			if let user = user {
				//Success
			} else if let errStr = errStr {
				//Fail
				self?.displayAlert(userMessage: errStr)
			}
		}
	}
}

extension LoginController: EnableSignInDelegate {
	func signInTapEnable(_ signInTapEnable: SignIn) {
		guard let email = signIn.emailTextField.text else { return }
		guard let password = signIn.passwordTextField.text else { return }

		if email.checkIfEmailIsValid() == false {
			displayAlert(userMessage: "Please enter valid email")
		}
		if password.checkIfPasswordIsValid() == false {
			displayAlert(userMessage: "Please enter valid password")
		}
		let signin = SignInModel(email: email, password: password)
		APIManager.shareInstance.callingSignInAPI(signin: signin) {[weak self] (user, errStr) in
			if let user = user {
				//Success
			} else if let errStr = errStr {
				//Fail
				self?.displayAlert(userMessage: errStr)
			}
		}
	}
}

extension LoginController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

		let signUpTextFieldWithEmptyText: [String] = signUpTextFields
			.filter { $0 !== textField }
			.map { $0.text ?? "" }.filter { $0.isEmpty }

		let signInTextFieldWithEmptyText: [String] = signInTextFields
			.filter { $0 !== textField }
			.map { $0.text ?? "" }.filter { $0.isEmpty }

		signIn.signInBtn.isEnabled = (signInTextFieldWithEmptyText.count == 0 && !string.isEmpty)
		signUp.signUpBtn.isEnabled = (signUpTextFieldWithEmptyText.count == 0 && !string.isEmpty)
		return true
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let currentSignUpTextFieldReturn = signUpTextFields.first(where: { $0 === textField })
		let currentSignInTextFieldReturn = signInTextFields.first(where: { $0 === textField })
		if currentSignInTextFieldReturn == signIn.emailTextField {
			currentSignInTextFieldReturn?.resignFirstResponder()
			signIn.passwordTextField.becomeFirstResponder()
		} else if currentSignInTextFieldReturn == signIn.passwordTextField {
			currentSignInTextFieldReturn?.resignFirstResponder()
		}
		if currentSignUpTextFieldReturn == signUp.firstNameTextField {
			currentSignUpTextFieldReturn?.resignFirstResponder()
			signUp.lastNameTextField.becomeFirstResponder()
		} else if currentSignUpTextFieldReturn == signUp.lastNameTextField {
			currentSignUpTextFieldReturn?.resignFirstResponder()
			signUp.emailTextField.becomeFirstResponder()
		} else if currentSignUpTextFieldReturn == signUp.emailTextField {
			currentSignUpTextFieldReturn?.resignFirstResponder()
			signUp.passwordTextField.becomeFirstResponder()
		} else if currentSignUpTextFieldReturn == signUp.passwordTextField {
			currentSignUpTextFieldReturn?.resignFirstResponder()
			signUp.confirmPasswordTextField.becomeFirstResponder()
		} else if currentSignUpTextFieldReturn == signUp.confirmPasswordTextField {
			currentSignUpTextFieldReturn?.resignFirstResponder()
		}
		return true
	}
}
