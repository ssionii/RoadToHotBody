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
		var trainingIndex: Int
	}
	
	struct Response {
		var contents: [Content]?
	}
}

class FetchDetailContentsUseCase: FetchDetailContentsUseCaseProtocol {
	
	private let contentRepository: DetailContentRepository
	
	init(repository: DetailContentRepository) {
		self.contentRepository = repository
	}

	
	func execute(
		request: FetchDetailContentsUseCaseModels.Request
	) -> Observable<FetchDetailContentsUseCaseModels.Response> {
		let response = contentRepository.fetchDetailContents(request: request)
		print("response \(response)")
		return response
	}
}
