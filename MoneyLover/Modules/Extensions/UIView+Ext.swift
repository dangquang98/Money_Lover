//
//  UIView+Ext.swift
//  MoneyLover
//
//  Created by Interns on 8/21/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

extension UIView {
	func loadNib() -> UIView? {
		guard let nibName = type(of: self).description().components(separatedBy: ".").last else { return self }
		guard let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView else { return self }
		return view
	}
}
