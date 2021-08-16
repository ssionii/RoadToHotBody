//
//  PhotoCoordinator.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/14.
//

import UIKit
import Photos

protocol PhotoCoordinatorDelegate: AnyObject {
    func dismissPhtoLibrary(image: UIImage, imageUrl: NSURL)
}

class PhotoCoordinator: NSObject, Coordinator {
    var children: [Coordinator] = []
    var router: Router
    
    weak var delegate: PhotoCoordinatorDelegate?
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let photoController = UIImagePickerController()
        photoController.delegate = self
        router.present(photoController, animated: animated)
    }
}

extension PhotoCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print(info)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
           let imageUrl = info[UIImagePickerController.InfoKey.imageURL] {
            // save image url
            self.delegate?.dismissPhtoLibrary(image: image, imageUrl: imageUrl as! NSURL)
        }
        router.dismiss(animated: true)
        
    }
}

