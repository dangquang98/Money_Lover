//
//  TransactionModel.swift
//  MoneyLover
//
//  Created by Interns on 9/7/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import Foundation

struct TransactionModel: Decodable {
	enum Category {
		case expense(Expense)
		case income(Income)
		enum Expense: String {
			case bill = "RESTAURANT"
			case transportation = "TRANSPORTATION"
			case food = "SHOPPING"
			case others = "OTHERS"
		}
		enum Income: String {
			case salary = "SALARY"
			case gift = "FREELANCE"
			case sell = "INVESTMENT"
			case others = "OTHERS"
		}
	}

	let id: Int
	let type: String?
	let amount: Double
	let category: String?
	let description: String?
	var date: Date?
	let createdAt: String?
	let updatedAt: String?
	let userId: Int

	var commonDateString: String {
		return DateFormatter(format: .sortDate).stringFromDate(date) ?? ""
	}

	enum CodingKeys: String, CodingKey {
		case id
		case userId
		case createdAt
		case updatedAt
		case type
		case amount
		case category
		case description
		case date
	}
	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)
		let dateString = try values.decode(String.self, forKey: .date)
		if let date = DateFormatter(format: .serverDate).date(from: dateString) {
			self.date = date
		}
		self.id = try values.decode(Int.self, forKey: .id)
		self.createdAt = try values.decode(String.self, forKey: .createdAt)
		self.updatedAt = try values.decode(String.self, forKey: .updatedAt)
		self.type = try values.decode(String.self, forKey: .type)
		self.category = try values.decode(String.self, forKey: .category).capitalized
		self.amount = try values.decode(Double.self, forKey: .amount)
		self.description = try values.decode(String.self, forKey: .description)
		self.userId = try values.decode(Int.self, forKey: .userId)
	}

	init(id: Int, userId: Int, type: String?, amount: Double, category: String?, description: String?, date: Date?, createdAt: String?, updatedAt: String?) {
		self.id = id
		self.createdAt = createdAt
		self.updatedAt = updatedAt
		self.type = type
		self.category = category?.capitalized
		self.amount = amount
		self.description = description
		self.date = date
		self.userId = userId
	}

	func getCategory(name: String) -> Category? {
		if let expense = Category.Expense(rawValue: name) {
			return Category.expense(expense)
		} else if let income = Category.Income(rawValue: name) {
			return Category.income(income)
		} else {
			return nil
		}
	}
}
