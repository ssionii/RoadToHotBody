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
        let viewController = WriteMemoViewController(viewModel: makeWriteMemoViewModel())
        viewController.coordinatorDelegate = self
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
	
	private func makeWriteMemoViewModel() -> WriteMemoViewModel {
		switch from {
		case .Detail:
			return WriteDetailContentViewModel(muscle: muscle, date: date)
		case .Calendar:
			return WriteRecordMemoViewModel(muscle: muscle, date: date)
		}
	}
}

extension WriteMemoCoordinator: MemoVCCoordinatorDelegate {
    func dismissMemo() {
        router.dismiss(animated: true)
    }
}
