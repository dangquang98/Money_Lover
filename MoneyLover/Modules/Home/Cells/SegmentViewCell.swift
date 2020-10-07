//
//  SegmentViewCell.swift
//  MoneyLover
//
//  Created by Interns on 9/4/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

class SegmentViewCell: UICollectionViewCell {
	
	@IBOutlet weak var timeLabel: UILabel!

	func configSegment(name: String, isSelected: Bool) {
		timeLabel.textColor = isSelected ? UIColor.white : UIColor.darkGray
		timeLabel.text = name
	}
}
