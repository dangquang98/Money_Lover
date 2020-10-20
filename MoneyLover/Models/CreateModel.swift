//
//  CreateModel.swift
//  MoneyLover
//
//  Created by Interns on 10/8/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import Foundation

struct CreateModel: Encodable {
	let type: String
	let category: String
	let amount: Double
	let description: String
	let date: String
}
