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
			case bill = "Bills & Utilities"
			case transportation = "Transportation"
			case food = "Food & Drink"
			case others = "Others"
		}
		enum Income: String {
			case salary = "Salary"
			case gift = "Award/Gift"
			case sell = "Sell"
			case others = "Others"
		}
		var image: String {
			switch self {
			case .expense(let expense):
				switch expense {
				case .bill:
					return "Bill"
				case .transportation:
					return "Truck"
				case .food:
					return "Food"
				case .others:
					return "Money"
				}
			case .income(let income):
				switch income {
				case .salary:
					return "Salary"
				case .gift:
					return "Gift"
				case .sell:
					return "Price"
				case .others:
					return "Money"
				}
			}
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

	var commonDateString: String {
		return DateFormatter(format: .sortDate).stringFromDate(date) ?? ""
	}

	enum CodingKeys: String, CodingKey {
		case id
		case createdAt
		case updatedAt
		case type
		case category
		case amount
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
		self.category = try values.decode(String.self, forKey: .category)
		self.amount = try values.decode(Double.self, forKey: .amount)
		self.description = try values.decode(String.self, forKey: .description)
	}

	init(id: Int,
		type: String?,
		amount: Double,
		category: String?,
		description: String?,
		date: Date?,
		createdAt: String?,
		updatedAt: String?) {
		self.id = id
		self.createdAt = createdAt
		self.updatedAt = updatedAt
		self.type = type
		self.category = category
		self.amount = amount
		self.description = description
		self.date = date
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
