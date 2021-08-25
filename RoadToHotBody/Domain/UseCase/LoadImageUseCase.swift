//
//  FetchImageUseCase.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import Foundation
import RxSwift
import SDWebImage

protocol LoadImageUseCaseProtocol {
	func execute(request: LoadImageUseCaseModels.Request) -> Observable<LoadImageUseCaseModels.Response>
}

struct LoadImageUseCaseModels {
	struct Request {
		var url: URL
	}
	
	struct Response {
		var image: UIImage?
	}
}

class LoadImageUseCase: LoadImageUseCaseProtocol {
	func execute(request: LoadImageUseCaseModels.Request) -> Observable<LoadImageUseCaseModels.Response> {
		return Observable.create() { emit -> Disposable in
			SDWebImageManager.shared.loadImage(with: request.url, options: .retryFailed, progress: nil) { (image, _, error, _, _, _) in
				
				if let error = error {
					emit.onError(error)
					return
				}
				
				if let image = image {
					emit.onNext(LoadImageUseCaseModels.Response(image: image))
				}
			}
			return Disposables.create {}
		}
		
	}
}
