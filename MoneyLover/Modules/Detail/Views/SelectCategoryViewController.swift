//
//  SelectCategoryViewController.swift
//  MoneyLover
//
//  Created by Interns on 9/24/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

protocol SelectCategoryViewControllerDelegate: class {
	func selectCategoryViewController(_ viewController: SelectCategoryViewController, didSelectCategory category: String)
}

class SelectCategoryViewController: UIViewController {
	@IBOutlet weak var backBtn: UIButton!
	@IBOutlet weak var segmentControl: UISegmentedControl!

	weak var delegate: SelectCategoryViewControllerDelegate?

	@IBOutlet weak var tableView: UITableView!

	private var currentIndex: Int = 0 {
		didSet {
			tableView.reloadData()
		}
	}

	var transaction: TransactionModel?

    override func viewDidLoad() {
        super.viewDidLoad()
		segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
		tableView.delegate = self
		tableView.dataSource = self
    }
	func configCategory() {
	}

	func tableViewData() {
	}

	@IBAction func backTap(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}

	@IBAction func didChangeSegment(_ sender: UISegmentedControl) {
		currentIndex = sender.selectedSegmentIndex
	}
}

extension SelectCategoryViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellIdentifier", for: indexPath) as? CategoryListCell else { return UITableViewCell()}
		let category = currentIndex == 0 ? Constant.expensives[indexPath.row] : Constant.income[indexPath.row]
		var name = ""
		switch category {
		case .expense(let expensive):
			name = expensive.rawValue
		case .income(let income):
			name = income.rawValue
		}
		cell.configCategory(image: category.image, name: name)
		return cell
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch currentIndex {
		case 0:
			return Constant.expensives.count
		case 1:
			return Constant.income.count
		default:
			return 0
		}
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let category = currentIndex == 0 ? Constant.expensives[indexPath.row] : Constant.income[indexPath.row]
		// get category
		var name = ""
		switch category {
		case .expense(let expensive):
			name = expensive.rawValue
		case .income(let income):
			name = income.rawValue
		}
		delegate?.selectCategoryViewController(self, didSelectCategory: name)
		navigationController?.popViewController(animated: true)
	}
}
