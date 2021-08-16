//
//  PhotoCoordinator.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/14.
//

import UIKit
import Photos

protocol PhotoCoordinatorDelegate: AnyObject {
    func selectImage(imageUrl: NSURL)
    func selectVideo(videoUrl: NSURL)
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
        photoController.mediaTypes = ["public.movie", "public.image"]
        router.present(photoController, animated: animated)
    }
}

extension PhotoCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print(info)
        
        if info[UIImagePickerController.InfoKey.mediaType] as! String == "public.image" {
            if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] {
                self.delegate?.selectImage(imageUrl: imageUrl as! NSURL)
            }
            router.dismiss(animated: true)
        } else if info[UIImagePickerController.InfoKey.mediaType] as! String == "public.movie" {
            if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] {
                self.delegate?.selectVideo(videoUrl: videoUrl as! NSURL)
            }
        }
    }
}

