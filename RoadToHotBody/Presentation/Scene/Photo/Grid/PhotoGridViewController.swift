//
//  PhotoGridViewController.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import UIKit
import RxSwift

class PhotoGridViewController: UIViewController {
	
	@IBOutlet weak var photoGridCollectionView: UICollectionView!
	
	private var photoUrls: [String] = [] {
		didSet {
			photoGridCollectionView.reloadData()
		}
	}
	
	private let viewModel: PhotoGridViewModel
	private let disposeBag = DisposeBag()
	
	private let minimumSpacing: CGFloat = 4
	
	init(viewModel: PhotoGridViewModel) {
		self.viewModel = viewModel
		
		super.init(nibName: "PhotoGridViewController", bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureCollectionView()
		bind()
    }
	
	private func configureCollectionView() {
		photoGridCollectionView.delegate = self
		photoGridCollectionView.dataSource = self
		
		photoGridCollectionView.register(PhotoGridCell.self, forCellWithReuseIdentifier: PhotoGridCell.ID)
	}
	
	private func bind() {
		let output = viewModel.transform(input: PhotoGridViewModel.Input())
		
		output.photos
			.withUnretained(self)
			.subscribe(onNext: { owner, urls in
				owner.photoUrls = urls
			})
			.disposed(by: disposeBag)
	}
}

extension PhotoGridViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photoUrls.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGridCell.ID, for: indexPath) as! PhotoGridCell
		cell.bind(urlString: photoUrls[indexPath.row])
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = collectionView.frame.width
		let itemPerRow: CGFloat = 3
		let padding = minimumSpacing * (itemPerRow - 1)
		let cellSize = (width - padding) / itemPerRow
		
		return CGSize(width: cellSize, height: cellSize)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return minimumSpacing
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return minimumSpacing
	}
}
