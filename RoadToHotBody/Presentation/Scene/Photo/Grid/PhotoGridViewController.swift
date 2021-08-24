//
//  PhotoGridViewController.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import UIKit

class PhotoGridViewController: UIViewController {
	
	@IBOutlet weak var photoGridCollectionView: UICollectionView!
	
	private let viewModel: PhotoGridViewModel
	
	init(viewModel: PhotoGridViewModel) {
		self.viewModel = viewModel
		
		super.init(nibName: "PhotoGridViewController", bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
