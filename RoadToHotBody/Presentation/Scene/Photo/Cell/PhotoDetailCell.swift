//
//  PhotoGridCell.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/25.
//

import UIKit
import RxSwift

protocol PhotoDetailCellDelegate: AnyObject {
	func cellDidLoad(index: Int, date: String)
}

class PhotoDetailCell: UICollectionViewCell {
	
	static let ID = "PhotoDetailCell"
	
	private let loadImageUseCase = LoadImageUseCase()
	private let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.clipsToBounds = true
		imageView.layer.masksToBounds = true
		return imageView
	}()
	
	private let disposeBag = DisposeBag()
	weak var delegate: PhotoDetailCellDelegate?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(imageView)
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
		imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
		imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
		imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
	}
	
	func configureCell(contentMode: UIView.ContentMode, radius: CGFloat = 0) {
		imageView.contentMode = contentMode
		imageView.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: radius)
	}
	
	func bind(photo: Photo) {
		
		guard let url = URL(string: photo.urlString) else { return }
		loadImageUseCase.execute(request: LoadImageUseCaseModels.Request(url: url))
			.map { response -> UIImage? in
				response.image
			}
			.compactMap { $0 }
			.withUnretained(self)
			.subscribe(
				onNext: { owner, image in
					owner.imageView.image = image
				},
				onError: { [weak self] error in
					print(error)
					guard let self = self else { return }
					self.imageView.backgroundColor = .systemGray5
				}
			)
			.disposed(by: disposeBag)
		
		self.delegate?.cellDidLoad(index: photo.index, date: photo.date ?? "")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
