//
//  UIViewController+Ext.swift
//  MoneyLover
//
//  Created by Interns on 9/3/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import Foundation
import UIKit

//extension UIViewController {
//	class func instantiateFromStoryboard (_ name: String) -> Self {
//		return instantiateFromStoryboardHelper(name)
//	}
//
//	fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T? {
//		let storyboard = UIStoryboard(name: name, bundle: nil)
//		guard let controller = storyboard.instantiateViewController(withIdentifier: "\(Self.self)") as? T else { return nil }
//		return controller
//	}
//}
protocol UIViewControllerFactory {}
extension UIViewController: UIViewControllerFactory {}

extension UIViewControllerFactory where Self: UIViewController {
	static func instantiate() -> Self {
		let name = String(describing: self).replacingOccurrences(of: "ViewController", with: "")
		let storyboard = UIStoryboard(name: name, bundle: nil)
		let initial = storyboard.instantiateInitialViewController()
		guard let controller = initial as? Self else {
			fatalError("Could not create \(name), please check your storyboard again.")
		}
		return controller
 }
}

extension UIViewController {
	func changeToRoot() {
		UIApplication.shared.windows.first?.rootViewController = self
		UIApplication.shared.windows.first?.makeKeyAndVisible()
	}
	func showDefaultAlert(_ message: String) {
		let alert = UIAlertController(title: "CONFIRMATION", message: "Message", preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
}

extension UITableView {
	@discardableResult
	func registerNib(_ cellClass: AnyClass...) -> Self {
		cellClass.forEach { register(UINib.init(nibName: String(describing: $0), bundle: nil), forCellReuseIdentifier: String(describing: $0)) }
		return self
	}
}
