//
//  TabBar.swift
//  MoneyLover
//
//  Created by Interns on 9/1/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

protocol TabBarDelegate: class {
	func didTapTabbarItem(_ sender: TabBar, index: Int)
}

class TabBar: BaseView {
	@IBOutlet weak var transactionImg: UIImageView!
	@IBOutlet weak var addTransImg: UIImageView!
	@IBOutlet weak var accountImg: UIImageView!
	@IBOutlet weak var addTranBtn: UIButton!
	@IBOutlet weak var transactionLabel: UILabel!
	@IBOutlet weak var accountLabel: UILabel!

	var isSelected: Bool? {
		didSet {
			if isSelected == true {
				transactionSelected()
			} else {
				transactionUnselected()
			}
		}
	}

	weak var delegate: TabBarDelegate?

	var transaction: TransactionModel?

	@IBAction func addTransTap(_ sender: UIButton) {
		didTapTabbarItem(index: 1)
	}
	@IBAction func transactionTap(_ sender: Any) {
		didTapTabbarItem(index: 0)
		isSelected = true
	}
	@IBAction func accountTap(_ sender: Any) {
		didTapTabbarItem(index: 2)
		isSelected = false
	}
	func didTapTabbarItem(index: Int) {
		delegate?.didTapTabbarItem(self, index: index)
	}

	func transactionSelected() {
		transactionImg.image = UIImage(named: "walletSelected")
		accountImg.image = UIImage(named: "settingUnselected")
		transactionLabel.textColor = UIColor.white
		accountLabel.textColor = UIColor.darkGray
	}

	func transactionUnselected() {
		accountImg.image = UIImage(named: "settingSelected")
		transactionImg.image = UIImage(named: "walletUnselected")
		accountLabel.textColor = UIColor.white
		transactionLabel.textColor = UIColor.darkGray
	}
}
