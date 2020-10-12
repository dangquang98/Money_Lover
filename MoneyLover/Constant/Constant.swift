//
//  Constant.swift
//  MoneyLover
//
//  Created by Interns on 8/25/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import Foundation

struct Constant {
	private static let base_url: String = "https://msi.center/2359"
	private static let versionPath: String = "/v1.0"
	private static let authPath: String = "\(base_url)/auth\(versionPath)"

	static let transactionsPath: String = "\(base_url)/transactions\(versionPath)"

	static let signup_url: String = "\(authPath)/register"
	static let signin_url: String = "\(authPath)/login"

	static let expensives: [TransactionModel.Category] = [.expense(.bill), .expense(.transportation), .expense(.food), .expense(.others)]
	static let income: [TransactionModel.Category] = [.income(.salary), .income(.gift), .income(.sell), .income(.others)]

//	static let getTransaction_url: String = "\(baseTransactions_url)/+\(dateFrom_url)+\(dateTo_url)"
}
