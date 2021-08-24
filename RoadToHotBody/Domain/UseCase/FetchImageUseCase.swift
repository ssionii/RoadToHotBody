//
//  FetchImageUseCase.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import Foundation
import RxSwift
import SDWebImage

protocol FetchImageUseCaseProtocol {
	func execute(request: FetchImageUseCaseModels.Request) -> Observable<FetchImageUseCaseModels.Response>
}

struct FetchImageUseCaseModels {
	struct Request {
		var url: URL
	}
	
	struct Response {
		var image: UIImage?
	}
}

class LoadImageUseCase: FetchImageUseCaseProtocol {
	func execute(request: FetchImageUseCaseModels.Request) -> Observable<FetchImageUseCaseModels.Response> {
		return Observable.create() { emit -> Disposable in
			SDWebImageManager.shared.loadImage(with: request.url, options: .allowInvalidSSLCertificates, progress: nil) { (image, _, error, _, _, _) in
				
				if let error = error {
					emit.onError(error)
					return
				}
				
				if let image = image {
					emit.onNext(FetchImageUseCaseModels.Response(image: image))
				}
			}
			return Disposables.create {}
		}
		
	}
}
