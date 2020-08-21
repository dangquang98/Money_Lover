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
    }
}
