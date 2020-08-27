//
//  Error.swift
//  MoneyLover
//
//  Created by Interns on 8/27/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import Foundation

struct MLError: Decodable {
	let statusCode: Int
	let message: String
	let error: String
}
