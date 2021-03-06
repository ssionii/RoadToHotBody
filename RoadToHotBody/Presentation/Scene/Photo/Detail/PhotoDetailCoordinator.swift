//
//  PhotoCoordinator.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import Foundation
import UIKit

protocol PhotoDetailCoordinatorDelegate: AnyObject {
	func deletePhoto()
}

class PhotoDetailCoordinator: Coordinator {
	var children: [Coordinator] = []
	var router: Router
	
	weak var delegate: PhotoDetailCoordinatorDelegate?
	
	private let photos: [Photo]
	private let pageIndex: Int
	private let photoType: PhotoType
	
	init(router: Router, photos: [Photo], pageIndex: Int, photoType: PhotoType) {
		self.router = router
		self.photos = photos
		self.pageIndex = pageIndex
		self.photoType = photoType
	}
	
	func present(animated: Bool, onDismissed: (() -> Void)?) {
		let viewModel = PhotoDetailViewModel(photos: photos, pageIndex: pageIndex, photoType: photoType)
		let viewController = PhotoDetailViewController(viewModel: viewModel)
		viewController.coordinatorDelegate = self
		router.present(viewController, animated: animated)
	}
}

extension PhotoDetailCoordinator: PhotoDetailVCCoordinatorDelegate {
	func deletePhoto() {
		delegate?.deletePhoto()
		// FIXME: NavigationRouter인 경우 뒤로가기로 처리
		router.dismiss(animated: true)
	}
}
