//
//  AppDelegateRouter.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/06.
//

import UIKit

public class AppDelegateRouter: Router {
	
	public let window: UIWindow
	
	public init(window: UIWindow) {
		self.window = window
	}
	
	public func present(_ viewController: UIViewController,
						animated: Bool,
						onDismissed: (() -> Void)?) {
		window.rootViewController = viewController
		window.makeKeyAndVisible()
	}
	
	public func dismiss(animated: Bool) {
		
	}
}
