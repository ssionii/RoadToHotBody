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
		recordViewController.coordinatorDelegate = self
	}
	
	func present(animated: Bool, onDismissed: (() -> Void)?) {
		router.present(recordViewController, animated: animated)
	}
	
	private func presentTimer() {
		let coordinator = TimerCoordinator(router: router)
		presentChild(coordinator, animated: true)
	}
	
	private func presentPhotoGrid() {
		let coordinator = PhotoGridCoordinator(router: router)
		presentChild(coordinator, animated: true)
	}
}

extension RecordCoordinator: RecordVCCoordinatorDelegate {
	func timerClicked() {
		self.presentTimer()
	}
	
	func photoClicked() {
		self.presentPhotoGrid()
	}
	
	func allRecordClicked() {
		
	}
}
