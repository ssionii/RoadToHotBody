//
//  PhotoGridCoordinator.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/25.
//

import Foundation

class PhotoGridCoordinator: Coordinator {
	var children: [Coordinator] = []
	var router: Router
	
	init(router: Router) {
		self.router = router
	}
	
	func present(animated: Bool, onDismissed: (() -> Void)?) {
		let viewModel = PhotoGridViewModel()
		let viewController = PhotoGridViewController(viewModel: viewModel)
		router.present(viewController, animated: animated)
	}
}
