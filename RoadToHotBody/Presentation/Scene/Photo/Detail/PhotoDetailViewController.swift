//
//  PhotoDetailViewController.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol PhotoDetailVCCoordinatorDelegate: AnyObject {
	func deletePhoto()
}

class PhotoDetailViewController: UIViewController {
	
	@IBOutlet weak var photoCollectionView: UICollectionView!
	@IBAction func deleteButtonClicked(_ sender: Any) {
		
		let alert = UIAlertController(title: "삭제 하시겠습니까?", message: "", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "네", style: .default, handler: { [weak self ] _ in
			guard let self = self else { return }
			self.deletePhotoIndex.onNext(self.displayedIndex)
		}))
		alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
		
		present(alert, animated: false, completion: nil)
	}
	
	private var photos: [Photo] = [] {
		didSet {
			photoCollectionView.reloadData()
		}
	}
	
	private var viewModel: PhotoDetailViewModel
	private let disposeBag = DisposeBag()
	weak var coordinatorDelegate: PhotoDetailVCCoordinatorDelegate?
	
	private let displayedPhotoDate = PublishSubject<String>()
	private var displayedIndex = 0
	private let deletePhotoIndex = PublishSubject<Int>()
	
	init(viewModel: PhotoDetailViewModel){
		self.viewModel = viewModel
		
		super.init(nibName: "PhotoDetailViewController", bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureUI()
		configureCollectionView()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
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
		let output = viewModel.transform(input: PhotoDetailViewModel.Input(deletePhotoIndex: deletePhotoIndex.asObservable()))
		
		output.photos
			.withUnretained(self)
			.subscribe(onNext: { owner, photos in
				owner.photos = photos
			})
			.disposed(by: disposeBag)
		
		output.pageIndex
			.withUnretained(self)
			.subscribe(onNext: { owner, pageIndex in
				owner.photoCollectionView.scrollToItem(at: IndexPath(row: pageIndex, section: 0), at: .left, animated: false)
			})
			.disposed(by: disposeBag)
		
		output.photoDeleted
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				NotificationCenter.default.post(name: .reloadCalendar, object: nil)
				owner.coordinatorDelegate?.deletePhoto()
			})
			.disposed(by: disposeBag)
		
		displayedPhotoDate
			.withUnretained(self)
			.subscribe(onNext: { owner, date in
				owner.navigationItem.title = date
			})
			.disposed(by: disposeBag)
	}
}

extension PhotoDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.photos.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoDetailCell.ID, for: indexPath) as! PhotoDetailCell
		cell.configureCell(contentMode: .scaleAspectFit)
		cell.delegate = self
		cell.bind(photo: photos[indexPath.row])
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
	}
}

extension PhotoDetailViewController: PhotoDetailCellDelegate {
	func cellDidLoad(index: Int, date: String) {
		self.displayedIndex = index
		
		self.displayedPhotoDate.onNext(DateHelper.dateTitle(date: date, dateFormat: "yyyy년 M월 d일"))
	}
}
