//
//  DetailCoordinator.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/10.
//

import UIKit

class DetailCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router
    
    private var detailViewController: DetailViewController?
	private let muscle: Muscle
	
    init(router: Router, muscle: Muscle) {
        self.router = router
        self.muscle = muscle
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let detailViewModel = DetailViewModel(muscle: muscle)
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        self.detailViewController = detailViewController
        detailViewController.coordinatorDelegate = self
        router.present(detailViewController, animated: true)
    }
    
	private func presentReadMemo(parentViewController: DetailViewController, content: Content) {
		let router = ModalNavigationRouter(parentViewController: parentViewController, modalPresentationStyle: .automatic)
        let coordinator = ReadMemoCoordinator(router: router, content: content)
        
		presentChild(coordinator, animated: true, onDismissed: {
			parentViewController.reloadView.onNext(())
		})
    }
    
    private func presentWriteMemo(parentViewController: DetailViewController, muscle: Muscle) {
        let router = ModalNavigationRouter(parentViewController: parentViewController, modalPresentationStyle: .automatic)
        let coordinator = WriteMemoCoordinator(router: router, muscle: muscle)
        
        presentChild(coordinator, animated: true, onDismissed: {
            parentViewController.reloadView.onNext(())
        })
    }
    
    private func presentPhoto(parentViewController: DetailViewController) {
        let router = NoNavigationRouter(rootViewController: parentViewController, modalPresentationStyle: .automatic)
        let coordinator = PhotoCoordinator(router: router)
        coordinator.delegate = self
        presentChild(coordinator, animated: true)
    }
}

extension DetailCoordinator: DetailVCCoordinatorDelegate {
  
    func readMemo(_ parentViewController: DetailViewController, content: Content) {
        self.presentReadMemo(parentViewController: parentViewController, content: content)
    }
    
	func writeMemoButtonClicked(_ parentViewController: DetailViewController) {
        self.presentWriteMemo(parentViewController: parentViewController, muscle: muscle)
    }
    
    func addPhotoButtomClicked(_ parentViewController: DetailViewController) {
        self.presentPhoto(parentViewController: parentViewController)
    }
}

extension DetailCoordinator: PhotoCoordinatorDelegate {
    func dismissPhtoLibrary(image: UIImage, imageUrl: NSURL) {
        print("image: \(image), imageUrl: \(imageUrl)")
    
        guard let detailViewController = self.detailViewController else { return }
        detailViewController.addedPhotoURL.onNext(imageUrl)
        
    }
}
