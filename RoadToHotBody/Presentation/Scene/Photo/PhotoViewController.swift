//
//  PhotoViewController.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/14.
//

import UIKit
import Photos

protocol PhotoVCCoordinatorDelegate: AnyObject {
    func dismissImagePicker(image: UIImage)
}

class PhotoViewController: UIViewController {
    
    weak var coordinatorDelegate: PhotoVCCoordinatorDelegate?
    
    private let imagePickerContorller = UIImagePickerController()
    
    init() {
        super.init(nibName: "PhotoViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePickerContorller.delegate = self
        imagePickerContorller.sourceType = .photoLibrary
        present(imagePickerContorller, animated: false, completion: nil)
    }
}

extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
           let imageURL = info[UIImagePickerController.InfoKey.imageURL] {
            // save image url
            
            self.coordinatorDelegate?.dismissImagePicker(image: image)
        }
    }
}
