//
//  DetailViewController.swift
//  MoneyLover
//
//  Created by Interns on 9/11/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	@IBOutlet weak var imageDetailLabel: UIImageView!
	@IBOutlet weak var nameDetailLabel: UILabel!
	@IBOutlet weak var amountDetailLabel: UILabel!
	@IBOutlet weak var dayDetailLabel: UILabel!
	@IBOutlet weak var usernameDetailLabel: UILabel!
	@IBOutlet weak var deleteBtn: UIButton!

	var transaction: TransactionModel? 
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.isTranslucent = true
		navigationController?.view.backgroundColor = .clear
		navigationController?.view.tintColor = UIColor.white
		navigationController?.isNavigationBarHidden = false
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTransaction))
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		configDetail()
    }

	func configDetail() {
		imageDetailLabel.image = UIImage(named: transaction?.category ?? "Others")
		nameDetailLabel.text = transaction?.category
		amountDetailLabel.text = String(transaction?.amount ?? 0)
//		dayDetailLabel.text = transaction?.date?.toString(format: "EEEE, dd MM yyyy")
		dayDetailLabel.text = DateFormatter(format: .fullDate).stringFromDate(transaction?.date)
		usernameDetailLabel.text = "username"
	}
	@objc func editTransaction() {
		let editController = AddEditViewController.instantiate()

		let navigationController = UINavigationController(rootViewController: editController)
		editController.transaction = transaction
		editController.addEditType = .editTransaction
		self.present(navigationController, animated: true, completion: nil)
	}
	@IBAction func deleteTransaction(_ sender: UIButton) {
	}
}
