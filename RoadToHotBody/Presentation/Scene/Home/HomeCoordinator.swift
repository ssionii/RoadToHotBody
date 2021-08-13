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
		
		let homeViewModel = HomeViewModel()
		self.homeViewController = HomeViewController(viewModel: homeViewModel)
		homeViewController.coordinatorDelegate = self
	}
	
	func present(animated: Bool, onDismissed: (() -> Void)?) {
		router.present(homeViewController, animated: false)
	}
	
	private func presentDetail(muscle: Muscle) {
        let coordinator = DetailCoordinator(router: router, muscle: muscle)
        presentChild(coordinator, animated: true)
	}
}

extension HomeCoordinator: HomeVCCoordinatorDelegate {
	func buttonClicked(muscle: Muscle) {
		self.presentDetail(muscle: muscle)
	}
}
