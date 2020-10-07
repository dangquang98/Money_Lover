//
//  AppDelegate.swift
//  MoneyLover
//
//  Created by Interns on 8/19/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	enum AppDeleteScreen {
		case home
		case onboarding
	}

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
		if UserDefaultToken.tokenInstance.isLogin() {
			changeWindow(to: .home)
		} else {
			changeWindow(to: .onboarding)
		}
		UIApplication.shared.statusBarStyle = .lightContent
        return true
    }
}

extension AppDelegate {
	func changeWindow(to screen: AppDeleteScreen) {
		window = UIWindow(frame: UIScreen.main.bounds)
		switch screen {
		case .home:
			let homeStoryBoard = UIStoryboard(name: "Container", bundle: nil)
			let containerViewController = homeStoryBoard.instantiateViewController(withIdentifier: "ContainerViewController")
			window?.makeKeyAndVisible()
			window?.rootViewController = containerViewController
		case .onboarding:
			let onboardingStoryBoard = UIStoryboard(name: "Onboarding", bundle: nil)
			let onboardingViewController = onboardingStoryBoard.instantiateViewController(withIdentifier: "OnboardingViewController")
			window?.makeKeyAndVisible()
			window?.rootViewController = onboardingViewController
		}
	}
}
