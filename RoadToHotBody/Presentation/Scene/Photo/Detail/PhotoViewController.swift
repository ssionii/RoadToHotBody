//
//  PhotoViewController.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoDetailViewController: UIViewController {
	
	@IBOutlet weak var photoCollectionView: UICollectionView!
	
	private var photoUrlStrings: [String] = [] {
		didSet {
			photoCollectionView.reloadData()
		}
	}
	
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
		
		configureUI()
		configureCollectionView()
		bind()
    }
	
	private func configureUI() {
		self.navigationItem.backButtonTitle = ""
	}
	
	private func configureCollectionView() {
		self.photoCollectionView.delegate = self
		self.photoCollectionView.dataSource = self
		
		self.photoCollectionView.register(PhotoDetailCell.self, forCellWithReuseIdentifier: PhotoDetailCell.ID)
	}
	
	private func bind() {
		let output = viewModel.transform(input: PhotoViewModel.Input())
		
		output.urlStrings
			.withUnretained(self)
			.subscribe(onNext: { owner, urlStrings in
				owner.photoUrlStrings = urlStrings
			})
			.disposed(by: disposeBag)
		
		output.index
			.withUnretained(self)
			.subscribe(onNext: { owner, index in
				owner.photoCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .right, animated: false)
			})
			.disposed(by: disposeBag)
	}
}

extension PhotoDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.photoUrlStrings.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoDetailCell.ID, for: indexPath) as! PhotoDetailCell
		cell.configureCell(contentMode: .scaleAspectFill)
		cell.bind(urlString: photoUrlStrings[indexPath.row])
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
	}

}
