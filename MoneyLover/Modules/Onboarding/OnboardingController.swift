//
//  OnboardingController.swift
//  MoneyLover
//
//  Created by Interns on 8/19/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

class OnboardingController: UIViewController, UIScrollViewDelegate {
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var btnNewUse: UIButton!
	@IBOutlet weak var btnOldUse: UIButton!

	var slides: [Slide] = []
    override func viewDidLoad() {
        super.viewDidLoad()

		btnNewUse.layer.cornerRadius = 5
		btnOldUse.layer.cornerRadius = 5

		scrollView.delegate = self

		slides = createSlides()
		setupSlideScrollView(slides: slides)

		pageControl.numberOfPages = slides.count
		pageControl.currentPage = 0
		view.bringSubviewToFront(pageControl)
    }

	override func viewDidLayoutSubviews() {
		pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
	}
	
    func createSlides() -> [Slide] {
        //let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide

		if let slide1 = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as? Slide {
			slide1.imageView.image = UIImage(named: "pigcoin")
			slide1.labelTitle.text = "Manage money efficiently with Money Lover"
			slides.append(slide1)
		}

		if let slide2 = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as? Slide {
			slide2.imageView.image = UIImage(named: "piechart")
			slide2.labelTitle.text = "Manage your personal finance and achieve your financial goals"
			slides.append(slide2)
		}

		if let slide3 = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as? Slide {
			slide3.imageView.image = UIImage(named: "transfer")
			slide3.labelTitle.text = "Keep track of every penny with in-depth reports"
			slides.append(slide3)
		}
		if let slide4 = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as? Slide {
			slide4.imageView.image = UIImage(named: "bell")
			slide4.labelTitle.text = "Notify you to input your transaction daily"
			slides.append(slide4)
		}
		return slides
    }

	func setupSlideScrollView(slides: [Slide]) {
		scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height/3 * 2)

		for i in 0 ..< slides.count {
			slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height/3 * 2)
			scrollView.addSubview(slides[i])
		}
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
		pageControl.currentPage = Int(pageIndex)
	}
	@IBAction func signUpTap(_ sender: UIButton) {
		let loginController = LoginViewController.instantiate()
		loginController.loginType = .signup
		loginController.completionHandler = {[weak self] in
			let homeController = ContainerViewController.instantiate()
			homeController.changeToRoot()
		}
		self.present(loginController, animated: true, completion: nil)
	}
	@IBAction func loginTap(_ sender: UIButton) {
		let loginController = LoginViewController.instantiate()
		loginController.loginType = .signin
		loginController.completionHandler = {[weak self] in
			let homeController = ContainerViewController.instantiate()
			homeController.changeToRoot()
		}
		self.present(loginController, animated: true, completion: nil)
	}
}
