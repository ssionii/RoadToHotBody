//
//  TimerCoordinator.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/26.
//

import Foundation

class TimerCoordinator: Coordinator {
	var children: [Coordinator] = []
	var router: Router
	
	init(router: Router) {
		self.router = router
	}
	
	func present(animated: Bool, onDismissed: (() -> Void)?) {
		let viewController = TimerViewController()
		router.present(viewController, animated: animated)
	}
}
