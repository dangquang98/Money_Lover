//
//  StringExtension.swift
//  MoneyLover
//
//  Created by Interns on 8/26/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import Foundation

extension String {
	func checkIfEmailIsValid() -> Bool {
		let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
		let validEmail = NSPredicate(format: "SELF MATCHES %@", emailRegex)
		return validEmail.evaluate(with: self)
	}
	func checkIfPasswordIsValid() -> Bool {
		let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[$@$!%*#?&]).{8,}$"
		let validPassword = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
		return validPassword.evaluate(with: self)
	}
}
