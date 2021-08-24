//
//  FetchPhotos.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import RxSwift

protocol FetchPhotosUseCaseProtocol {
	func execute(request: FetchPhotosUseCaseModels.Request) -> Observable<FetchPhotosUseCaseModels.Response>
}

struct FetchPhotosUseCaseModels {
	struct Request {
		
	}
	
	struct Response {
		var photoUrls: [String]
	}
}

class FetchPhotosUseCase: FetchPhotosUseCaseProtocol {
	
	private let recordRepository: RecordRepositoryProtocol
	
	init(repository: RecordRepositoryProtocol) {
		self.recordRepository = repository
	}
	
	func execute(request: FetchPhotosUseCaseModels.Request) -> Observable<FetchPhotosUseCaseModels.Response> {
		return recordRepository.fetchPhotos()
			.asObservable()
			.map { urls -> FetchPhotosUseCaseModels.Response in
				return FetchPhotosUseCaseModels.Response(photoUrls: urls)
			}
	}
}
