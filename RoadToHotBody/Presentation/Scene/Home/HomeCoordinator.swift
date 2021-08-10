//
//  HomeCoordinator.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import UIKit

class HomeCoordinator: Coordinator {
	
	var children: [Coordinator] = []
	var router: Router
	
	var homeViewController: HomeViewController
	
	init(router: Router) {
		self.router = router
		
		self.homeViewController = HomeViewController()
		homeViewController.coordinatorDelegate = self
	}
	
	func present(animated: Bool, onDismissed: (() -> Void)?) {
		router.present(homeViewController, animated: false)
	}
	
	
	private func presentDetail(name: String) {
		let detailViewController = DetailViewController(name: name)
		router.present(detailViewController, animated: true)
	}
}

extension HomeCoordinator: HomeVCCoordinatorDelegate {
	func buttonClicked(name: String) {
		self.presentDetail(name: name)
	}
}