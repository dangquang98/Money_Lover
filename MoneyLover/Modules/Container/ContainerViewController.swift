//
//  ContainerViewController.swift
//  MoneyLover
//
//  Created by Interns on 9/29/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit
enum TabbarItem: Int {
	case transaction = 0
	case add = 1
	case account = 2
}

class ContainerViewController: UIViewController {
	@IBOutlet weak var tabBar: TabBar!
	@IBOutlet weak var contentView: UIView!

	var selectedTabbarItem: TabbarItem = .transaction {
		didSet {
			didChangeTabbar()
		}
	}

	var homeModule: UINavigationController = {
		let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
		let homeViewController = homeStoryboard.instantiateViewController(identifier: "HomeViewController")
		let navigationController = UINavigationController(rootViewController: homeViewController)
		return navigationController
	}()

	var accountModule: UINavigationController = {
		let accountStoryboard = UIStoryboard(name: "Account", bundle: nil)
		let accountViewController = accountStoryboard.instantiateViewController(identifier: "AccountViewController")
		let navigationController = UINavigationController(rootViewController: accountViewController)
		return navigationController
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		tabBar.delegate = self
		// add child vc to parent vc
		addChild(homeModule)
		contentView.addSubview(homeModule.view)
		homeModule.view.frame = contentView.bounds
		homeModule.didMove(toParent: self)

		// add child vc to parent vc
		addChild(accountModule)
		contentView.addSubview(accountModule.view)
		accountModule.view.frame = contentView.bounds
		accountModule.didMove(toParent: self)

		selectedTabbarItem = .transaction
    }
	func didChangeTabbar() {
		switch selectedTabbarItem {
		case .transaction:
			homeModule.view.isHidden = false
			accountModule.view.isHidden = true
		case .add:
			// home vC
			guard let homeViewController = homeModule.viewControllers.first as? HomeViewController else { return }
			let addController = AddEditViewController.instantiate()
			addController.delegate = homeViewController
			let navigationController = UINavigationController(rootViewController: addController)
			addController.addEditType = .addTransaction
			self.present(navigationController, animated: true, completion: nil)
		case .account:
			homeModule.view.isHidden = true
			accountModule.view.isHidden = false
		}
	}
}

extension ContainerViewController: TabBarDelegate {
	func didTapTabbarItem(_ sender: TabBar, index: Int) {
		homeModule.viewControllers.first as? HomeViewController
		selectedTabbarItem = TabbarItem(rawValue: index) ?? .transaction
	}
}
