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
		let coordinator = ReadMemoCoordinator(router: router, from: .Detail, content: content)
        
		presentChild(coordinator, animated: true, onDismissed: {
			parentViewController.reloadView.onNext(())
		})
    }
	
    private func presentWriteMemo(parentViewController: DetailViewController, muscle: Muscle) {
        let router = ModalNavigationRouter(parentViewController: parentViewController, modalPresentationStyle: .automatic)
		let coordinator = WriteMemoCoordinator(router: router, from: .Detail, muscle: muscle, date: nil)
        
        presentChild(coordinator, animated: true, onDismissed: {
            parentViewController.reloadView.onNext(())
        })
    }
    
    private func presentPhotoLibrary(parentViewController: DetailViewController) {
        let router = NoNavigationRouter(rootViewController: parentViewController, modalPresentationStyle: .automatic)
        let coordinator = PhotoLibraryCoordinator(router: router)
        coordinator.delegate = self
        presentChild(coordinator, animated: true)
    }
	
	private func presentPhoto(photoIndex: Int, urlString: String) {
		let coordinator = PhotoDetailCoordinator(router: router, photos: [Photo(index: photoIndex, urlString: urlString)], index: 0)
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
    
    func photoLibraryButtonClicked(_ parentViewController: DetailViewController) {
        self.presentPhotoLibrary(parentViewController: parentViewController)
    }
	
	func photoDetailClicked(photoIndex: Int, imageUrlString: String) {
		self.presentPhoto(photoIndex: photoIndex, urlString: imageUrlString)
	}
}

extension DetailCoordinator: PhotoLibraryCoordinatorDelegate {
    func selectImage(imageUrl: NSURL) {
        guard let detailViewController = self.detailViewController else { return }
        detailViewController.addedPhotoURL.onNext(imageUrl)
    }
    
    func selectVideo(videoUrl: NSURL) {
        guard let detailViewController = self.detailViewController else { return }
        detailViewController.addedVideoURL.onNext(videoUrl)
    }
}

extension DetailCoordinator: PhotoDetailCoordinatorDelegate {
	func deletePhoto() {
		detailViewController?.reloadView.onNext(())
	}
}
