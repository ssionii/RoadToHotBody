//
//  FetchDetailContentUseCase.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/11.
//

import RxSwift

protocol FetchDetailContentUseCaseProtocol {
	func execute(
		request: FetchDetailContentUseCaseModels.Request
	) -> Observable<FetchDetailContentUseCaseModels.Response>
}

enum FetchDetailContentUseCaseModels {
	struct Request {
		var index: Int
	}
	
	struct Response {
		var content: Content
	}
}

class FetchDetailContentUseCase: FetchDetailContentUseCaseProtocol {
	
	private let contentRepository: TrainingDetailRepository
	
	init(repository: TrainingDetailRepository) {
		self.contentRepository = repository
	}

	func execute(
		request: FetchDetailContentUseCaseModels.Request
	) -> Observable<FetchDetailContentUseCaseModels.Response> {
		return contentRepository.fetchDetailContent(request: request)
	}
}
