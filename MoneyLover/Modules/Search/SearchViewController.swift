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
	@IBOutlet weak var searchButton: UIButton!

	let tableViewSearchTransactionID = "TableSearchTransaction"

	var searchTransactions: String?

	var transactions: [TransactionModel] = [] {
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
		setupTableView()
    }
	func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.registerNib(TransactionCell.self)
	}

	@IBAction func searchTap(_ sender: Any) {
		getTransactions(dateString: APIManager.shareInstance.selectedMonth ?? DateFormatter(format: .monthYear).string(from: Date()))
	}
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionCell else { return UITableViewCell()}
		let transaction = transactions[indexPath.row]
		cell.configTransaction(transaction: transaction)
		return cell
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return transactions.count
	}

}

extension SearchViewController {
	func getTransactions(dateString: String) {
		APIManager.shareInstance.callingGetTransactionAPI(monthYearStr: dateString) { [weak self] transactions, error in
			guard let self = self else { return }
			if let error = error {
				self.showDefaultAlert(error)
			} else {
				guard var transactions = transactions else { return }
				transactions = transactions.filter({ (transaction) -> Bool in
					return transaction.category?.contains(self.searchBar.text ?? "") ?? false
				})
				self.transactions = transactions
			}
		}
	}
}
