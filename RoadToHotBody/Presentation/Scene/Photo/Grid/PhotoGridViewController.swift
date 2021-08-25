//
//  PhotoGridViewController.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import UIKit
import RxSwift

protocol PhotoGridVCCoordinatorDelegate: AnyObject {
	func photoClicked(photos: [Photo], index: Int)
}

class PhotoGridViewController: UIViewController {
	
	@IBOutlet weak var photoGridCollectionView: UICollectionView!
	
	private var photos: [Photo] = [] {
		didSet {
			photoGridCollectionView.reloadData()
		}
	}
	
	private let viewModel: PhotoGridViewModel
	private let disposeBag = DisposeBag()
	weak var coordinatorDelegate: PhotoGridVCCoordinatorDelegate?
	
	private let minimumSpacing: CGFloat = 4
	
	let reloadView = BehaviorSubject<Void>(value: ())
	
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
		
		photoGridCollectionView.register(PhotoDetailCell.self, forCellWithReuseIdentifier: PhotoDetailCell.ID)
	}
	
	private func bind() {
		let output = viewModel.transform(input: PhotoGridViewModel.Input(reloadView: reloadView.asObserver()))
		
		output.photos
			.withUnretained(self)
			.subscribe(onNext: { owner, photos in
				owner.photos = photos
			})
			.disposed(by: disposeBag)
		
		reloadView
			.subscribe(onNext: { _ in
				print("reload")
			})
	}
}

extension PhotoGridViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoDetailCell.ID, for: indexPath) as! PhotoDetailCell
		cell.bind(photo: photos[indexPath.row])
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
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.coordinatorDelegate?.photoClicked(photos: photos, index: indexPath.row)
	}
}
