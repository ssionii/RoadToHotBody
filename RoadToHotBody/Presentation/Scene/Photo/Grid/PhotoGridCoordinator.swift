//
//  PhotoGridCoordinator.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/25.
//

import Foundation

class PhotoGridCoordinator: Coordinator {
	var children: [Coordinator] = []
	var router: Router
	
	private var viewController: PhotoGridViewController?
	
	init(router: Router) {
		self.router = router
		
		let viewModel = PhotoGridViewModel()
		viewController = PhotoGridViewController(viewModel: viewModel)
		viewController?.coordinatorDelegate = self
	}
	
	func present(animated: Bool, onDismissed: (() -> Void)?) {
		guard let vc = self.viewController else { return }
		router.present(vc, animated: animated)
	}
	
	private func presentPhotoDetail(photos: [Photo], index: Int) {
		guard let vc = self.viewController else { return }
		let router = ModalNavigationRouter(parentViewController: vc)
		let coordinator = PhotoDetailCoordinator(router: router, photos: photos, index: index)
		coordinator.delegate = self
		presentChild(coordinator, animated: true)
	}
}

extension PhotoGridCoordinator: PhotoGridVCCoordinatorDelegate {
	func photoClicked(photos: [Photo], index: Int) {
		presentPhotoDetail(photos: photos, index: index)
	}
}

extension PhotoGridCoordinator: PhotoDetailCoordinatorDelegate {
	func deletePhoto() {
		viewController?.reloadView.onNext(())
	}
}
