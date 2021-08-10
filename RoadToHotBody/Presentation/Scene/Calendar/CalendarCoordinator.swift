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
		
		self.calendarViewController = CalendarViewController()
	}
	
	func present(animated: Bool, onDismissed: (() -> Void)?) {
		router.present(calendarViewController, animated: false)
	}
}
