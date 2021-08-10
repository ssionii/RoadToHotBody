//
//  TabRouter.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/09.
//

import UIKit

public class TabBarRouter: NSObject {
	
	let navigationController: UINavigationController
	private let tabBarController: UITabBarController
	
	public init(navigationController: UINavigationController) {
		self.navigationController = navigationController
		self.tabBarController = UITabBarController()
		super.init()
	}
}

extension TabBarRouter: Router {
	
	public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {

		if navigationController.viewControllers.count == 0 {
			presentTabBar()
		}

		if let viewControllers = self.tabBarController.viewControllers,
			viewControllers.contains(viewController) {
			// TODO: 띄우기
			tabBarController.selectedViewController = viewController
		} else {
			guard var viewControllers = self.tabBarController.viewControllers
			else {
				self.tabBarController.viewControllers = [viewController]
				return
			}

			viewControllers.append(viewController)
			self.tabBarController.viewControllers = viewControllers
		}
	}
	
	public func dismiss(animated: Bool) {
		
	}
	
	private func presentTabBar() {
//		navigationController.setNavigationBarHidden(true, animated: false)
		navigationController.modalPresentationStyle = .overFullScreen
		navigationController.viewControllers = [tabBarController]
	}
	
}
