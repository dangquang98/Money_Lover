//
//  SignUpModel.swift
//  MoneyLover
//
//  Created by Interns on 8/25/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import Foundation

struct SignUpModel: Encodable {
	let firstName: String
	let lastName: String
	let email: String
	let password: String
}
