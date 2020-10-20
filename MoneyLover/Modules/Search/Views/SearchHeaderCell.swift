//
//  SearchCell.swift
//  MoneyLover
//
//  Created by Interns on 10/16/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

class SearchHeaderCell: BaseView {
	@IBOutlet weak var nameSearchLabel: UILabel!

	func configSearchHeader(nameDate: String) {
		nameSearchLabel.text = nameDate
	}
}
