//
//  RecordCoordinator.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import Foundation

class RecordCoordinator: Coordinator {
	var children: [Coordinator] = []
	var router: Router
	
	var recordViewController: RecordViewController
	
	init(router: Router) {
		self.router = router
		
		let viewModel = RecordViewModel()
		recordViewController = RecordViewController(viewModel: viewModel)
	}
	
	func present(animated: Bool, onDismissed: (() -> Void)?) {
		router.present(recordViewController, animated: true)
	}
}
