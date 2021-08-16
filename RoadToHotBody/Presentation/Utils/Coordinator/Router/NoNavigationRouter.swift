//
//  NoNavigationRouter.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/14.
//

import UIKit

public class NoNavigationRouter: NSObject {

    private let rootViewController: UIViewController
    private var onDismiss: (() -> Void)?
    
    private var modalPresentationStyle: UIModalPresentationStyle
    
    public init(
        rootViewController: UIViewController,
        modalPresentationStyle: UIModalPresentationStyle
    ) {
        self.rootViewController = rootViewController
        self.modalPresentationStyle = modalPresentationStyle
        
        super.init()
    }
}

extension NoNavigationRouter: Router {
    
    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        self.onDismiss = onDismissed
        
        rootViewController.modalPresentationStyle = self.modalPresentationStyle
        rootViewController.present(viewController, animated: animated, completion: nil)
        
    }
    
    public func dismiss(animated: Bool) {
        rootViewController.dismiss(animated: animated, completion: onDismiss)
        
    }
}
