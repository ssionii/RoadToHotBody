//
//  PhotoGridCell.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/25.
//

import UIKit
import RxSwift

class PhotoGridCell: UICollectionViewCell {
	
	static let ID = "PhotoGridCell"
	
	private let loadImageUseCase = LoadImageUseCase()
	private let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = UIView.ContentMode.scaleAspectFill
		imageView.clipsToBounds = true
		imageView.backgroundColor = .systemGray5
		return imageView
	}()
	
	private let disposeBag = DisposeBag()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	
		addSubview(imageView)
		
		self.imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
		imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
		imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
		imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
	}
	
	func bind(urlString: String) {
		
		guard let url = URL(string: urlString) else { return }
		
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
				onError: { error in
					print(error)
				}
			)
			.disposed(by: disposeBag)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
