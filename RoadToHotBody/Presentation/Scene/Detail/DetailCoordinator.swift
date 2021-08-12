//
//  DetailCoordinator.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/10.
//

import UIKit

class DetailCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router
    
    private var muscleName: String
	
    init(router: Router, muscleName: String) {
        self.router = router
        self.muscleName = muscleName
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let detailViewModel = DetailViewModel(muscleName: muscleName)
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        detailViewController.coordinatorDelegate = self
        router.present(detailViewController, animated: true)
    }
    
	private func presentMemo(parentViewController: DetailViewController, memoType: MemoType, content: Content?) {
		let router = ModalNavigationRouter(parentViewController: parentViewController, modalPresentationStyle: .automatic)
        let coordinator = MemoCoordinator(router: router, memoType: memoType, content: content)

		presentChild(coordinator, animated: true, onDismissed: {
			parentViewController.reloadView.onNext(())
		})
    }
}

extension DetailCoordinator: DetailVCCoordinatorDelegate {
	func writeMemoButtonClicked(_ parentViewController: DetailViewController) {
		self.presentMemo(parentViewController: parentViewController, memoType: .Write, content: nil)
    }
	
	func readMemo(_ parentViewController: DetailViewController, content: Content) {
		self.presentMemo(parentViewController: parentViewController, memoType: .Read, content: content)
	}
}