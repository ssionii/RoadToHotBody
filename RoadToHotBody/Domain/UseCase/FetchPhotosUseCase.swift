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
		var photos: [Photo]
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
			.map { photos -> FetchPhotosUseCaseModels.Response in
				let sortedPhotos = photos.sorted(by: { $0.date ?? "" > $1.date ?? "" })
				return FetchPhotosUseCaseModels.Response(photos: sortedPhotos)
			}
	}
}
