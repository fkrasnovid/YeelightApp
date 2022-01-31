//
//  AppDelegate.swift
//  YeelightApp
//
//  Created by Filipp K on 28.01.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = UINavigationController(rootViewController: DiscoverDevicesViewController())
		window?.makeKeyAndVisible()

		return true
	}
}

