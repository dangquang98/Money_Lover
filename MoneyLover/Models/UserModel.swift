//
//  UserModel.swift
//  MoneyLover
//
//  Created by Interns on 8/25/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import Foundation

struct UserModel: Decodable {
	struct User: Decodable {
		let id: Int?
		let createdAt: String?
		let updatedAt: String?
		let firstName: String?
		let lastName: String?
		let email: String?
		let role: String?
		let avatar: String?
		let phone: String?
		let balance: Int?
	}
	struct Token: Decodable {
		let expiresIn: Int?
		let accessToken: String?
	}
	let user: User
	let token: Token
}
