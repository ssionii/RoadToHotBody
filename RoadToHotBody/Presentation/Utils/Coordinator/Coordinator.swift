//
//  Coordinator.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/06.
//

import UIKit

public protocol Coordinator: class {
	var children: [Coordinator] { get set }
	var router: Router { get }
	
	func present(animated: Bool, onDismissed: (() -> Void)?)
	func dismiss(animated: Bool)
	func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (() -> Void)?)
}

extension Coordinator {
	
	public func dismiss(animated: Bool) {
		router.dismiss(animated: animated)
	}
	
	public func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (() -> Void)? = nil) {
		children.append(child)
		child.present(animated: animated, onDismissed: { [weak self, weak child] in
			guard let self = self,
				  let child = child else {
				return
			}
			self.removeChild(child)
			onDismissed?()
		})
	}
	
	private func removeChild(_ child: Coordinator) {
		children = children.filter { $0 !== child }
	}
}

