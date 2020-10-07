//
//  TransactionHeaderView.swift
//  MoneyLover
//
//  Created by Interns on 9/9/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

class TransactionHeaderView: BaseView {

	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var monthYearLabel: UILabel!
	@IBOutlet weak var totalPerDayLabel: UILabel!

	func configDate(nameDate: Date, nameTotalPerDay: Double) {
		dateLabel.text = DateFormatter(format: .day).stringFromDate(nameDate)
		dayLabel.text = DateFormatter(format: .fullDay).stringFromDate(nameDate)
		monthYearLabel.text = DateFormatter(format: .monthYear).stringFromDate(nameDate)
		totalPerDayLabel.text = String(nameTotalPerDay)
	}
}
