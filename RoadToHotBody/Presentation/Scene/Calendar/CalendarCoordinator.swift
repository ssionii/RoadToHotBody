//
//  CalendarCoordinator.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import UIKit

class CalendarCoordinator: Coordinator {
	var children: [Coordinator] = []
	var router: Router
	
	var calendarViewController: CalendarViewController
	
	init(router: Router) {
		self.router = router
		
		let viewModel = CalendarViewModel()
		self.calendarViewController = CalendarViewController(viewModel: viewModel)
		self.calendarViewController.coordinatorDelegate = self
	}
	
	func present(animated: Bool, onDismissed: (() -> Void)?) {
		router.present(calendarViewController, animated: false)
	}
	
	private func presentWriteMemo(parentViewController: UIViewController, date: String) {
		let router = ModalNavigationRouter(parentViewController: parentViewController, modalPresentationStyle: .automatic)
		let coordinator = WriteMemoCoordinator(router: router, from: .Calendar, muscle: nil, date: date)
		presentChild(coordinator, animated: true) {
			self.calendarViewController.reloadView.onNext(())
		}
		
	}
}

extension CalendarCoordinator: CalendarVCCoordinatorDelegate {
	func writeMemoButtonClicked(_ viewController: UIViewController, date: String) {
		self.presentWriteMemo(parentViewController: viewController, date: date)
	}
	
	func photoLibraryButtonClicked(_ viewController: UIViewController, date: String) {
		
	}
	
	func addExerciseButtonClicked(_ viewController: UIViewController, date: String) {
		
	}
	
	
}
