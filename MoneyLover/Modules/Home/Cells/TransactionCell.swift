//
//  TransactionCell.swift
//  MoneyLover
//
//  Created by Interns on 9/8/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
	@IBOutlet weak var categoryImage: UIImageView!
	@IBOutlet weak var categoryLabel: UILabel!
	@IBOutlet weak var amountLabel: UILabel!

	func configTransaction(transaction: TransactionModel) {
		categoryImage.image = #imageLiteral(resourceName: "Bill")
		categoryLabel.text = transaction.category
		amountLabel.text = String(transaction.amount)
		amountLabel.textColor = transaction.type == "INCOME" ? .blue : .red
	}
}
