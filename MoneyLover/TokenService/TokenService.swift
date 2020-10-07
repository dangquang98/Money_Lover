//
//  TokenService.swift
//  MoneyLover
//
//  Created by Interns on 8/28/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

protocol TokenService {
	func saveToken(_ token: String)
	func getToken() -> String
	func isLogin() -> Bool
	func removeToken()
}

class UserDefaultToken: TokenService {
	static let tokenInstance = UserDefaultToken()
	let userDefault = UserDefaults.standard
	static let key = "USER_LOGIN_KEY"

	enum Key: String {
		case token
	}

	func saveToken(_ token: String) {
		userDefault.set(token, forKey: Key.token.rawValue)
	}

	func getToken() -> String {
		if let token = userDefault.object(forKey: Key.token.rawValue) as? String {
			return token
		} else {
			return ""
		}
	}

	func isLogin() -> Bool {
		if getToken() == "" {
			return false
		} else {
			return true
		}
	}

	func removeToken() {
		userDefault.removeObject(forKey: Key.token.rawValue)
	}
}
