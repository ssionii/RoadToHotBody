//
//  fetchDetailContentsUseCase.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import RxSwift

protocol FetchDetailContentsUseCaseProtocol {
	func execute(
		request: FetchDetailContentsUseCaseModels.Request
	) -> Observable<FetchDetailContentsUseCaseModels.Response>
}

enum FetchDetailContentsUseCaseModels {
	struct Request {
		var muscleIndex: Int
	}
	
	struct Response {
		var contents: [Content]
	}
}

class FetchDetailContentsUseCase: FetchDetailContentsUseCaseProtocol {
	
	private let detailContentRepository: DetailContentRepository
	
	init(repository: DetailContentRepository) {
		self.detailContentRepository = repository
	}

	func execute(
		request: FetchDetailContentsUseCaseModels.Request
	) -> Observable<FetchDetailContentsUseCaseModels.Response> {
		return detailContentRepository.fetchDetailContents(muscleIndex: request.muscleIndex)
			.asObservable()
			.map { contents -> FetchDetailContentsUseCaseModels.Response in
				return FetchDetailContentsUseCaseModels.Response(contents: contents)
			}
	}
}
