//
//  HomeViewController.swift
//  MoneyLover
//
//  Created by Interns on 8/28/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

extension UIViewController {
//	func createFakeTransactions() -> [TransactionModel] {
//		let transaction1 = TransactionModel(id: 1, type: "INCOME", amount: 100000, category: "SALARY", description: "Salary", date: Date(), createdAt: "", updatedAt: "")
//		let transaction2 = TransactionModel(id: 2, type: "INCOME", amount: -100000, category: "TRANSPORTATION", description: "Salary", date: Date(), createdAt: "", updatedAt: "")
//		let transaction3 = TransactionModel(id: 3, type: "EXPENSE", amount: 100000, category: "SHOPPING", description: "Salary", date: Date(), createdAt: "", updatedAt: "")
//		let transaction4 = TransactionModel(id: 4, type: "INCOME", amount: -100000, category: "OTHERS", description: "Salary", date: Date().addingTimeInterval(-86400), createdAt: "", updatedAt: "")
//		let transaction5 = TransactionModel(id: 5, type: "EXPENSE", amount: 100000, category: "RESTAURANT", description: "Salary", date: Date().addingTimeInterval(-86400*2), createdAt: "", updatedAt: "")
//		let transaction11 = TransactionModel(id: 6, type: "INCOME", amount: 100000, category: "SALARY", description: "Salary", date: Date().addingTimeInterval(-86400*30), createdAt: "", updatedAt: "")
//		let transaction22 = TransactionModel(id: 7, type: "EXPENSE", amount: -100000, category: "FREELANCE", description: "Salary", date: Date().addingTimeInterval(-86400*31), createdAt: "", updatedAt: "")
//		let transaction33 = TransactionModel(id: 8, type: "INCOME", amount: 100000, category: "INVESTMENT", description: "Salary", date: Date().addingTimeInterval(-86400*60), createdAt: "", updatedAt: "")
//		let transaction44 = TransactionModel(id: 9, type: "EXPENSE", amount: -100000, category: "SALARY", description: "Salary", date: Date().addingTimeInterval(-86400*61), createdAt: "", updatedAt: "")
//
//		return [transaction1, transaction2, transaction3, transaction4, transaction5, transaction11, transaction22, transaction33, transaction44]
//
//	}
	func createTransactionDict(from transactions: [TransactionModel], by format: FormatString.Format = .monthYear) -> [String: [TransactionModel]] {
		let sortedTransactions = transactions.sorted { (first, second) -> Bool in
			if let first = first.date, let second = second.date {
				return first < second
			}
			return false
		}
		let groupedTransactions = Dictionary<String, [TransactionModel]>(grouping: sortedTransactions, by: { transaction in
			if let date = transaction.date {
				return DateFormatter(format: format).string(from: date)
			}
			return ""
		})
		return groupedTransactions
	}
}
class HomeViewController: UIViewController {

	enum TableCellType {
		case total(Double, Double)
		case group([TransactionModel])
	}
	@IBOutlet weak var nameLbl: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var collectionViewA: UICollectionView!
	@IBOutlet weak var totalTransactionLabel: UILabel!
	@IBOutlet weak var threedotsButton: UIButton!

	let collectionViewAIdentifier = "CollectionViewCellA"
	let tableViewTotalFlowID = "TableFlowID"
	let tableViewTransactionID = "TransactionCell"
	let cellHeaderHeight: CGFloat = 50
	let sessionSpacingHeight: CGFloat = 20

	var tableCellTypes: [TableCellType] = []

	var selectedMonth: String? {
		didSet {
			getTransactions(dateString: selectedMonth ?? DateFormatter(format: .monthYear).string(from: Date()))
		}
	}

	var months: [String] = {
		guard let currentYear = Int(DateFormatter(format: .year).string(from: Date())) else { return [] }
		return Array(1...12).map { return "\($0 < 10 ? "0\($0)" : "\($0)")/\(currentYear)" }
	}()

	var transactionDict: [String: [TransactionModel]] = [:] {
		didSet {
			guard transactionDict.count != 0 else { return }
			if let selectedMonth = selectedMonth {
				reloadTableViewData()
				collectionViewA.reloadData()
			}
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = true
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		title = "Transactions"

		setupTableView()
		setupCollectionView()

//		loadDataIfNeed(transactions: createFakeTransactions())
		getTransactions(dateString: DateFormatter(format: .monthYear).string(from: Date()))
    }
	func reloadTableViewData() {
		let defaultMonth = DateFormatter(format: .monthYear).string(from: Date())
		let transactions = transactionDict[selectedMonth ?? defaultMonth] ?? []
		tableCellTypes = generateTableViewData(transactions)
		tableView.reloadData()
	}

	func generateTableViewData(_ transactions: [TransactionModel]) -> [TableCellType] {
		var cells: [TableCellType] = []
		let inflow = transactions.reduce(0) { (result, transaction) -> Double in
			if transaction.type == "INCOME" {
				return result + transaction.amount
			} else {
				return result
			}
		}
		let outflow = transactions.reduce(0) { (result, transaction) -> Double in
			if transaction.type == "EXPENSE" {
				return result + transaction.amount * -1
			} else {
				return result
			}
		}
		let sum = TableCellType.total(inflow, outflow)
		cells.append(sum)
		//TODOs: Filter group by date
		if let selectedDate = selectedMonth {
			let group = groupBillOfMonthByDate(fullBillOfMonth: transactionDict[selectedDate])
			cells.append(contentsOf: group)
		} else {
			cells.append(.group([]))
		}
		return cells
	}

	func groupBillOfMonthByDate(fullBillOfMonth: [TransactionModel]?) -> [TableCellType] {
		guard let fullBillOfMonth = fullBillOfMonth else { return []}
		var tableCellTypes: [TableCellType] = []
		let sortedTransactionByDate = fullBillOfMonth.sorted { (first, second) -> Bool in
			if let first = first.date, let second = second.date {
				return first < second
			}
			return false
		}
		var lastDay: String!

		for (index, transaction) in sortedTransactionByDate.enumerated() {
			if index == 0 {
				tableCellTypes.append(TableCellType.group([transaction]))
			} else {
				if transaction.commonDateString == lastDay {
					let lastGroup = tableCellTypes.last
					// lastgroup is TableCellType.group
					if case .group(let transactions) = lastGroup {
						let newTransactions = transactions + [transaction]
						tableCellTypes.removeLast()
						tableCellTypes.append(.group(newTransactions))
					} else {
						fatalError()
					}
				} else {
					tableCellTypes.append(.group([transaction]))
				}
			}
			lastDay = transaction.commonDateString
		}
		return tableCellTypes
	}
	@IBAction func displayThreeDotsSheet(_ sender: Any) {
		let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

		let jumpToTodayAction = UIAlertAction(title: "Jump to today", style: .default, handler: nil)
		let viewByTransactionAction = UIAlertAction(title: "View by transaction", style: .default, handler: nil)
		let searchForTransactionAction = UIAlertAction(title: "Search for transaction", style: .default) { (_) in
			self.searchTap()
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		optionMenu.addAction(jumpToTodayAction)
		optionMenu.addAction(viewByTransactionAction)
		optionMenu.addAction(searchForTransactionAction)
		optionMenu.addAction(cancelAction)

		self.present(optionMenu, animated: true)
	}
	func searchTap() {
		let searchController = SearchViewController.instantiate()
		let navigationController = UINavigationController(rootViewController: searchController)
		self.present(navigationController, animated: true, completion: nil)
	}

	func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.registerNib(TransactionCell.self)
	}

	func setupCollectionView() {
		collectionViewA.delegate = self
		collectionViewA.dataSource = self
	}
}
extension HomeViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.bounds.width/3, height: 50)
	}
}
extension HomeViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return months.count
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0.0
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0.0
	}
}

extension HomeViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewAIdentifier, for: indexPath) as? SegmentViewCell else { return UICollectionViewCell()}
		let name = months[indexPath.row]
		cellA.configSegment(name: name, isSelected: selectedMonth == name)
		return cellA
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView === collectionViewA {
			let sortedTransactionKeys = transactionDict.keys.sorted(by: <)
			let index = indexPath.row
			let name = months[index]

			self.selectedMonth = name
			// change data

			collectionView.reloadData()
			collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
			collectionView.reloadItems(at: [])
		}
	}
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return tableCellTypes.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let cellTypes = tableCellTypes
		switch section {
		case 0:
			return 1
		default:
			if case let .group(transactions) = cellTypes[section] {
				return transactions.count
			} else {
				return 0
			}
		}
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section != 0 {
			let cellType = tableCellTypes[section]
			if case let .group(transactions) = cellType, let nameDate = transactions.first?.date {
				let total = transactions.reduce(0) { (result, transaction) -> Double in
					if transaction.type == "INCOME" {
						return result + transaction.amount
					} else if transaction.type == "EXPENSE" {
						return result + transaction.amount * -1
					} else {
						return result
					}
				}
				let headerView = TransactionHeaderView()
				headerView.configDate(nameDate: nameDate, nameTotalPerDay: total)
				return headerView
			} else {
				return nil
			}
		}
		return UIView()
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return section != 0 ? cellHeaderHeight : 0
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return sessionSpacingHeight
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let footerView = UIView()
		footerView.backgroundColor = UIColor.black
		return footerView
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellType = tableCellTypes[indexPath.section]
		switch indexPath.section {
		case 0:
			if case let .total(inflow, outflow) = cellType {
				guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewTotalFlowID, for: indexPath) as? TotalFlowViewCell else { return UITableViewCell()}
				cell.configContent(inFlow: inflow, outFlow: outflow)
				return cell
			} else {
				return UITableViewCell()
			}
		default:
			if case let .group(transactionList) = cellType {
				guard let cell2 = tableView.dequeueReusableCell(withIdentifier: tableViewTransactionID, for: indexPath) as? TransactionCell else { return UITableViewCell()}
				let transaction = transactionList[indexPath.row]
				cell2.configTransaction(transaction: transaction)
				return cell2
			} else {
				return UITableViewCell()
			}
		}
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let cellType = tableCellTypes[indexPath.section]
		if indexPath.section != 0 {
			let detailController = DetailViewController.instantiate()
			if case let .group(transactionList) = cellType {
				let transaction = transactionList[indexPath.row]
				detailController.transaction = transaction
				navigationController?.pushViewController(detailController, animated: true)
			}
		}
	}
}

extension HomeViewController {
	//dateString = "07/2020"
	func getTransactions(dateString: String) {
		APIManager.shareInstance.callingGetTransactionAPI(monthYearStr: dateString) { [weak self] transactions, error in
			guard let self = self else { return }
			self.transactionDict = self.createTransactionDict(from: transactions)

		}
	}
}
