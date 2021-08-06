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
	
	public init(router: Router) {
		self.router = router
	}
	
	func present(animated: Bool, onDismissed: (() -> Void)?) {
		let viewController = MainViewController()
		router.present(viewController, animated: animated, onDismissed: onDismissed)
	}
}
