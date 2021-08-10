//
//  MainCoordinator.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/06.
//

import UIKit

class MainCoordinator: Coordinator {

	public var children: [Coordinator] = []
	public let router: Router
	
	private let baseNavigationController: UINavigationController
	
	public init(router: Router) {
		self.router = router
		
		if let router = router as? TabBarRouter {
			self.baseNavigationController = router.navigationController
		} else {
			self.baseNavigationController = UINavigationController()
		}
	}
	
	// UITabBarController 구성
	func present(animated: Bool, onDismissed: (() -> Void)?) {

		presentHome()
		presentCalendar()
	}
	
	func presentChild() {
		// navigaitonController..로 라우터 만들어서.. 해야하지 안하? ㅜㅡㅜ ㅜㅡㅜ 어려워 ㅜㅡㅜ
	}
	
	func presentHome() {
		let router = NavigationRouter(navigationController: baseNavigationController)
		let coordinator = HomeCoordinator(router: router)
		self.router.present(coordinator.homeViewController, animated: false)
	}
	
	func presentCalendar() {
		let router = NavigationRouter(navigationController: baseNavigationController)
		let coordinator = CalendarCoordinator(router: router)
		self.router.present(coordinator.calendarViewController, animated: false)
	}
}
