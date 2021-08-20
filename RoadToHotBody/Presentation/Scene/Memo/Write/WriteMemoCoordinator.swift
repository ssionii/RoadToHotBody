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
    
	private let from: OpenMemoFrom
    private let muscle: Muscle?
	private let date: String?
	
	init(router: Router, from: OpenMemoFrom, muscle: Muscle?, date: String?) {
        self.router = router
		self.from = from
        self.muscle = muscle
		self.date = date
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
		let viewModel = WriteMemoViewModel(from: from, muscle: muscle, date: date)
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

