//
//  PhotoViewController.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoViewController: UIViewController {
	
	@IBOutlet weak var photoImageView: UIImageView!
	
	private var viewModel: PhotoViewModel
	private let disposeBag = DisposeBag()
	
	init(viewModel: PhotoViewModel){
		self.viewModel = viewModel
		
		super.init(nibName: "PhotoViewController", bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		bind()

    }
	
	private func bind() {
		let output = viewModel.transform(input: PhotoViewModel.Input())
		
		output.image
			.drive(photoImageView.rx.image)
			.disposed(by: disposeBag)
	}
}
