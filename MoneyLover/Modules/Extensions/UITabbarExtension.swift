//
//  UITabbarExtension.swift
//  MoneyLover
//
//  Created by Interns on 8/31/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

extension UITabBar {

	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		var sizeThatFits = super.sizeThatFits(size)
		sizeThatFits.height = 10 // adjust your size here
		return sizeThatFits
	}
}
