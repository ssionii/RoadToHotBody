//
//  ReadMemoCoordinator.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/14.
//

import Foundation

enum OpenMemoFrom {
	case Detail
	case Calendar
}

class ReadMemoCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router
    
	private let from: OpenMemoFrom
    private let content: Content
    
	init(router: Router, from: OpenMemoFrom, content: Content) {
        self.router = router
		self.from = from
        self.content = content
    }
	
    func present(animated: Bool, onDismissed: (() -> Void)?) {
		let viewController = ReadMemoViewController(viewModel: makeViewModel())
		viewController.coordinatorDelegate = self
		router.present(viewController, animated: animated, onDismissed: onDismissed)
       
    }
	
	private func makeViewModel() -> ReadMemoViewModel {
		switch from {
		case .Calendar:
			return ReadRecordMemoViewModel(content: self.content)
		case .Detail:
			return ReadDetailContentMemoViewModel(content: self.content)
		}
	}
}

extension ReadMemoCoordinator: MemoVCCoordinatorDelegate {
    func dismissMemo() {
        router.dismiss(animated: true)
    }
}
