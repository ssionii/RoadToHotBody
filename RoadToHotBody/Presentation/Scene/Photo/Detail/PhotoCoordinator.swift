//
//  PhotoCoordinator.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import Foundation
import UIKit

class PhotoCoordinator: Coordinator {
	var children: [Coordinator] = []
	var router: Router
	
	private let url: String
	
	init(router: Router, url: String) {
		self.router = router
		self.url = url
	}
	
	func present(animated: Bool, onDismissed: (() -> Void)?) {
		let viewModel = PhotoViewModel(url: url)
		let viewController = PhotoViewController(viewModel: viewModel)
		router.present(viewController, animated: animated)
	}
}
