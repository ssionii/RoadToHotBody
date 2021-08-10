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
    
    private func presentMemo(parentViewController: UIViewController) {
        let router = ModalNavigationRouter(parentViewController: parentViewController, modalPresentationStyle: .pageSheet)
        let coordinator = MemoCoordinator(router: router)
        presentChild(coordinator, animated: true)
    }
}

extension DetailCoordinator: DetailVCCoordinatorDelegate {
    func memoButtonClicked(_ parentViewController: UIViewController) {
        self.presentMemo(parentViewController: parentViewController)
    }
}
