//
//  AppDelegate.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/06.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	public lazy var coordinator = MainCoordinator(router: router)
	public lazy var router = AppDelegateRouter(window: window!)
	public lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		coordinator.present(animated: true, onDismissed: nil)
		
		return true
	}
}

