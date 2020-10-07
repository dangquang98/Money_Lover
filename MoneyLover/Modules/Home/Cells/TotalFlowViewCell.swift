//
//  ContentViewCell.swift
//  MoneyLover
//
//  Created by Interns on 9/7/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

class TotalFlowViewCell: UITableViewCell {

	@IBOutlet weak var inFlowLabel: UILabel!
	@IBOutlet weak var outFlowLabel: UILabel!
	@IBOutlet weak var totalFlowLabel: UILabel!

	func configContent(inFlow: Double, outFlow: Double) {
		inFlowLabel.text = String(inFlow)
		outFlowLabel.text = String(outFlow)
		totalFlowLabel.text = String(inFlow + outFlow)
	}
}
