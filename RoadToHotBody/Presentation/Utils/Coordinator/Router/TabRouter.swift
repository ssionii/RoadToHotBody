//
//  TabRouter.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/09.
//

import UIKit

public class TabBarRouter: NSObject {
	
	private let tabController: UITabBarController
}

extension TabBarRouter: Router {
	
	public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
		
	}
	
	public func dismiss(animated: Bool) {
		<#code#>
	}
	
	
}
