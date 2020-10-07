//
//  CategoryListCell.swift
//  MoneyLover
//
//  Created by Interns on 9/28/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

class CategoryListCell: UITableViewCell {
	@IBOutlet weak var categoryListImage: UIImageView!
	@IBOutlet weak var categoryListLabel: UILabel!

	func configCategory(image: String, name: String) {
		categoryListImage.image = UIImage(named: image)
		categoryListLabel.text = name
	}
}
