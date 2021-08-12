//
//  AppCoordinator.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/09.
//

import UIKit
import CoreData

class AppCoordinator: Coordinator {
	var children: [Coordinator] = []
	var router: Router
	
	init(router: Router) {
		self.router = router
	}
	
	func present(animated: Bool, onDismissed: (() -> Void)?) {
		// UINavgationController를 가장 바닥으로 깔기
		let navigationViewController = UINavigationController()
		router.present(navigationViewController, animated: false)
		
		presentMain(navigationViewController: navigationViewController)
	}
	
	private func presentMain(navigationViewController: UINavigationController) {
		let router = TabBarRouter(navigationController: navigationViewController)
		let coordinator = MainCoordinator(router: router)
		presentChild(coordinator, animated: false)
	}
}
