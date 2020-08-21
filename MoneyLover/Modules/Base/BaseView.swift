//
//  BaseView.swift
//  MoneyLover
//
//  Created by Interns on 8/21/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

class BaseView: UIView {
	var view: UIView!

	override init(frame: CGRect) {
		super.init(frame: frame)
		nibInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		nibInit()
	}

	private func nibInit() {
		view = loadNib()
		view.frame = bounds
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(view)
	}
}
