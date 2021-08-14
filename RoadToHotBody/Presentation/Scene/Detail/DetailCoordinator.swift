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
    
	private var muscle: Muscle
	
    init(router: Router, muscle: Muscle) {
        self.router = router
        self.muscle = muscle
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
		let detailViewModel = DetailViewModel(muscle: muscle)
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        detailViewController.coordinatorDelegate = self
        router.present(detailViewController, animated: true)
    }
    
	private func presentReadMemo(parentViewController: DetailViewController, content: Content) {
		let router = ModalNavigationRouter(parentViewController: parentViewController, modalPresentationStyle: .automatic)
        let coordinator = ReadMemoCoordinator(router: router, content: content)
        
		presentChild(coordinator, animated: true, onDismissed: {
			parentViewController.reloadView.onNext(())
		})
    }
    
    private func presentWriteMemo(parentViewController: DetailViewController, muscle: Muscle) {
        let router = ModalNavigationRouter(parentViewController: parentViewController, modalPresentationStyle: .automatic)
        let coordinator = WriteMemoCoordinator(router: router, muscle: muscle)
        
        presentChild(coordinator, animated: true, onDismissed: {
            parentViewController.reloadView.onNext(())
        })
    }
}

extension DetailCoordinator: DetailVCCoordinatorDelegate {
	func writeMemoButtonClicked(_ parentViewController: DetailViewController) {
        self.presentWriteMemo(parentViewController: parentViewController, muscle: muscle)
    }
	
	func readMemo(_ parentViewController: DetailViewController, content: Content) {
        self.presentReadMemo(parentViewController: parentViewController, content: content)
	}
}
