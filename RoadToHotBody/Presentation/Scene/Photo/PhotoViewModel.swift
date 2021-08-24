//
//  PhotoViewModel.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class PhotoViewModel {
	struct Input {
		
	}
	
	struct Output {
		var image: Driver<UIImage>
	}
	
	private let loadImageUseCase = LoadImageUseCase()
	
	private let urlString: String
	
	init(url: String) {
		self.urlString = url
	}
	
	func transform(input: Input) -> Output {
		
		guard let url = URL(string: urlString) else {
			return Output(image: Driver.never())
		}
		
		let image = loadImageUseCase.execute(request: LoadImageUseCaseModels.Request(url: url))
			.map { response -> UIImage? in
				response.image
			}
			.compactMap { $0 }
			.asDriver(onErrorJustReturn: UIImage())
		
		return Output(image: image)
	}

}
