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
	private let content: Content?
    
	init(router: Router, memoType: MemoType, content: Content? = nil) {
        self.router = router
		
		self.memoType = memoType
		self.content = content
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
		
		let memoViewModel = MemoViewModel(memoType: memoType, content: content)
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
