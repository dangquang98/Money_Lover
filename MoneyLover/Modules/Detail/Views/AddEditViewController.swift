//
//  AddEditViewController.swift
//  MoneyLover
//
//  Created by Interns on 9/23/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

enum AddEditType {
	case addTransaction
	case editTransaction
}
class AddEditViewController: UIViewController {
	@IBOutlet weak var titleTransaction: UILabel!
	@IBOutlet weak var amountTransactionTextField: UITextField!
	@IBOutlet weak var transactionImage: UIImageView!
	@IBOutlet weak var selectTransactionLabel: UILabel!
	@IBOutlet weak var noteTransactionTextField: UITextField!
	@IBOutlet weak var dateTransactionTextField: UITextField!

	@IBOutlet weak var saveCreateTransaction: UIButton!
	@IBOutlet weak var cancelAddEditBtn: UIButton!
	@IBOutlet weak var selectCategoryButton: UIButton!

	weak var datePicker: UIDatePicker?

	var getType: String = ""

	var transaction: TransactionModel?

	var addEditType: AddEditType = .addTransaction
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = true
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		amountTransactionTextField.delegate = self
		configEdit()
    }

	func configEdit() {
//		guard titleTransaction != nil else { return }

		switch addEditType {
		case .addTransaction:
			titleTransaction.text = "Add transaction"
		case .editTransaction:
			titleTransaction.text = "Edit transaction"
			transactionImage.image = UIImage(named: transaction?.category ?? "Others")
		}

		amountTransactionTextField.text = String(transaction?.amount ?? 0)
		selectTransactionLabel.text = transaction?.category
		noteTransactionTextField.text = transaction?.description

		dateTransactionTextField.text = DateFormatter(format: .serverDate).stringFromDate(transaction?.date)
		// need to be fixed
		dateTransactionTextField.showDatePicker(target: self, date: Date(), doneHandler: #selector(doneTap), cancelHandler: #selector(cancelTap))
	}

	@objc func doneTap() {
		if let datePicker = dateTransactionTextField.inputView as? UIDatePicker {
//			dateTransactionTextField.text = datePicker.date.toString(format: "EEEE, dd MM yyyy")
			dateTransactionTextField.text = DateFormatter(format: .serverDate).stringFromDate(datePicker.date)
			dateTransactionTextField.resignFirstResponder()
		}
	}
	@objc func cancelTap() {
		dateTransactionTextField.resignFirstResponder()
	}
	@IBAction func selectCategoryTap(_ sender: Any) {
		let selectCategoryController = SelectCategoryViewController.instantiate()
		selectCategoryController.delegate = self
		selectCategoryController.transaction = transaction
		navigationController?.pushViewController(selectCategoryController, animated: true)
	}
	@IBAction func cancelAddEditTap(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	@IBAction func saveAddTap(_ sender: Any) {
		switch addEditType {
		case .addTransaction:
			let type = getType
			guard let category = selectTransactionLabel.text?.uppercased() else { return }
			guard let amount =	Int(amountTransactionTextField.text!) ?? 0 else { return }
			guard let description = noteTransactionTextField.text else { return }
			guard let date = dateTransactionTextField.text  else { return }
			let create = CreateModel(type: type, category: category, amount: amount, description: description, date: date)
			APIManager.shareInstance.callingCreateTransactionAPI(create: create) {[weak self] (transactions, error) in
				if let transactions = transactions {
					print(transactions)
					self?.dismiss(animated: true, completion: nil)
				} else if let error = error {
					print(error)
				}
			}
		case .editTransaction:
			print("edit")
		}
	}
}

extension AddEditViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if textField == amountTransactionTextField {
			let allowedCharacters = CharacterSet(charactersIn: "+0123456789")
			let characterSet = CharacterSet(charactersIn: string)
			return allowedCharacters.isSuperset(of: characterSet)
		}
		return true
	}
}

extension UITextField {
	func showDatePicker(target: UIViewController, date: Date?, doneHandler: Selector, cancelHandler: Selector) {
		let datePicker = UIDatePicker()
		datePicker.date = date ?? Date()
		datePicker.preferredDatePickerStyle = .wheels
		datePicker.datePickerMode = .dateAndTime

		let toolBar = UIToolbar()

		toolBar.barStyle = .default
		toolBar.tintColor = UIColor.black
		toolBar.sizeToFit()

		let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: target, action: cancelHandler)
		let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: doneHandler)
		let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

		toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
		inputView = datePicker
		inputAccessoryView = toolBar
	}
}

extension AddEditViewController: SelectCategoryViewControllerDelegate {
	func selectCategoryViewController(_ viewController: SelectCategoryViewController, didSelectCategory category: TransactionModel.Category) {
		//get category
		var name = ""
		switch category {
		case .expense(let expensive):
			name = expensive.rawValue.capitalized
			getType = "EXPENSE"
		case .income(let income):
			name = income.rawValue.capitalized
			getType = "INCOME"
		}
		selectTransactionLabel.text = name
		transactionImage.image = UIImage(named: name)
	}
}
