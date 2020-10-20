//
//  AccountViewController.swift
//  MoneyLover
//
//  Created by Interns on 9/29/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
	@IBOutlet weak var accountImage: UIImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var logoutButton: UIButton!

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = true
	}
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	@IBAction func logoutTap(_ sender: Any) {
		UserDefaultToken.tokenInstance.forceLoggout()
	}
}
