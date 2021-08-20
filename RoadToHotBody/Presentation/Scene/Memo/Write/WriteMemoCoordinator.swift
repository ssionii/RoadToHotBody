//
//  WriteMemoCoordinator.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/14.
//

import Foundation

class WriteMemoCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router
    
    private let muscle: Muscle?
	private let date: String?
	
	init(router: Router, muscle: Muscle?, date: String?) {
        self.router = router
        self.muscle = muscle
		self.date = date
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
		let viewModel = WriteMemoViewModel(muscle: muscle, date: date)
        let viewController = WriteMemoViewController(viewModel: viewModel)
        viewController.coordinatorDelegate = self
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}

extension WriteMemoCoordinator: MemoVCCoordinatorDelegate {
    func dismissMemo() {
        router.dismiss(animated: true)
    }
}

