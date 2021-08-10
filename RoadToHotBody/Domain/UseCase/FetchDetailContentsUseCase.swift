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
		var muscleName: String
	}
	
	struct Response {
		var contents: [Content]?
	}
}

class FetchDetailContentUseCase: FetchDetailContentsUseCaseProtocol {
	
	let contentRepository: ContentRepositoryProtocol
	
	init(repository: ContentRepositoryProtocol) {
		self.contentRepository = repository
	}

	
	func execute(
		request: FetchDetailContentsUseCaseModels.Request
	) -> Observable<FetchDetailContentsUseCaseModels.Response> {
		return contentRepository.fetchDetailContents(request: request)
	}
}
