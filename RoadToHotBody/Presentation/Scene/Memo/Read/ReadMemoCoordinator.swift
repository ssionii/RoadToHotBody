//
//  ReadMemoCoordinator.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/14.
//

import Foundation

class ReadMemoCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router
    
    private let content: Content
    
    init(router: Router, content: Content) {
        self.router = router
        self.content = content
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewModel = ReadMemoViewModel(content: content)
        let viewController = ReadMemoViewController(viewModel: viewModel)
        viewController.coordinatorDelegate = self
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}

extension ReadMemoCoordinator: MemoVCCoordinatorDelegate {
    func dismissMemo() {
        router.dismiss(animated: true)
    }
}
