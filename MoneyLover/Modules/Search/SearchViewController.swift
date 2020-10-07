//
//  SearchViewController.swift
//  MoneyLover
//
//  Created by Interns on 10/1/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!

	let tableViewSearchTransactionID = "TableSearchTransaction"

	var transactionDict: [String: [TransactionModel]] = [:]

	var transactionKeys: [String] = [] {
		didSet {
			tableView.reloadData()
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = true
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		searchBar.delegate = self

		setupTableView()
    }
	func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.registerNib(TransactionCell.self)
	}
}

extension SearchViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//		let transactions = createFakeTransactions()
//		transactionDict = createTransactionDict(from: transactions, by: .fullDate)
//		transactionKeys = Array(transactionDict.keys)
	}
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionCell else { return UITableViewCell()}
		let key = transactionKeys[indexPath.section]
		let transactionModels = transactionDict[key]
		if let transaction = transactionModels?[indexPath.row] {
			cell.configTransaction(transaction: transaction)
			return cell
		} else {
			return UITableViewCell()
		}
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return transactionKeys.count
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section >= 0 && section < transactionKeys.count {
			let index = transactionKeys[section]
			return transactionDict[index]?.count ?? 0
		}
		return 0
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let nameDate = transactionKeys[section]
		let testLabel = UILabel()
		testLabel.text = nameDate
		testLabel.textColor = .white
			return testLabel
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 20
	}
}
