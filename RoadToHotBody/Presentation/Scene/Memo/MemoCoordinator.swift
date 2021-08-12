//
//  MemoCoordinator.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/10.
//

import UIKit

class MemoCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router
	
	private let memoType: MemoType
	private let contentIndex: Int?
    
	init(router: Router, memoType: MemoType, contentIndex: Int? = nil) {
        self.router = router
		
		self.memoType = memoType
		self.contentIndex = contentIndex
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
		
		let memoViewModel = MemoViewModel(memoType: memoType, contentIndex: contentIndex)
        let memoViewController = MemoViewController(viewModel: memoViewModel)
		memoViewController.coordinatorDelegate = self
		router.present(memoViewController, animated: true, onDismissed: onDismissed)
    }
}

extension MemoCoordinator: MemoVCCoordinatorDelegate {
	func dismissMemo(isSaved: Bool) {
		router.dismiss(animated: true)
		// TODO: isSaved가 false일 때 처리
	}
}
