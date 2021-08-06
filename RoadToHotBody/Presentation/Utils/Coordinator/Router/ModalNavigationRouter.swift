//
//  ModalNavigationRouter.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/06.
//

import UIKit

public class ModalNavigationRouter: NSObject {

	public let parentViewController: UIViewController
	
	private let navigationController = UINavigationController()
	private var onDismissForViewController: [UIViewController: (() -> Void)] = [:]
	
	private var modalPresentationStyle: UIModalPresentationStyle
	
	public init(
		parentViewController: UIViewController,
		modalPresentationStyle: UIModalPresentationStyle = .overFullScreen
	) {
		self.parentViewController = parentViewController
		self.modalPresentationStyle = modalPresentationStyle
		
		super.init()
		
		navigationController.delegate = self
	}
}

extension ModalNavigationRouter: Router {
	
	public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
		onDismissForViewController[viewController] = onDismissed
		if navigationController.viewControllers.count == 0 {
			presentModally(viewController, animated: animated)
		} else {
			navigationController.pushViewController(viewController, animated: animated)
		}
	}
	
	private func presentModally(_ viewController: UIViewController, animated: Bool) {
		addCloseButton(to: viewController)
		navigationController.setViewControllers([viewController], animated: false)
		navigationController.modalPresentationStyle = self.modalPresentationStyle
		parentViewController.present(navigationController, animated: animated, completion: nil)
	}

	private func addCloseButton(to viewController: UIViewController) {
		viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "닫기",
			style: .plain,
			target: self,
			action: #selector(cancelPressed)
		)
	}

	@objc private func cancelPressed() {
		performOnDismissed(for: navigationController.viewControllers.first!)
		dismiss(animated: true)
	}
	
	public func dismiss(animated: Bool) {
		performOnDismissed(for: navigationController.viewControllers.first!)
		parentViewController.dismiss(animated: animated, completion: nil)
	}
	
	private func performOnDismissed(for viewController: UIViewController) {
		guard let onDismiss = onDismissForViewController[viewController] else { return }
		onDismiss()
		onDismissForViewController[viewController] = nil
	}
}

extension ModalNavigationRouter: UINavigationControllerDelegate {
	
	public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		
		guard let dismissedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
			  !navigationController.viewControllers.contains(dismissedViewController) else {
			return
		}
		
		performOnDismissed(for: dismissedViewController)
	}
}
