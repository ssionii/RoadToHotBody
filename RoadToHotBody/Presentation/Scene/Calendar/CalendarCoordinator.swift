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
	}
	
	func present(animated: Bool, onDismissed: (() -> Void)?) {
		router.present(calendarViewController, animated: false)
	}
}
