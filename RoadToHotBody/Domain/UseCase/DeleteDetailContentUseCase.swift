//
//  DeleteDetailContentUseCase.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import RxSwift

protocol DeleteDetailContentUseCaseProtocol {
	func execute(
		request: DeleteDetailContentUseCaseModels.Request
	) -> Observable<DeleteDetailContentUseCaseModels.Response>
}

struct DeleteDetailContentUseCaseModels {
	struct Request {
		var index: Int
	}
	
	struct Response {
		var isSuccess: Bool
	}
}

class DeleteDetailContentUseCase: DeleteDetailContentUseCaseProtocol {
	
	private let detailContentRepository: DetailContentRepositoryProtocol
	
	init(repository: DetailContentRepositoryProtocol) {
		self.detailContentRepository = repository
	}
	
	func execute(request: DeleteDetailContentUseCaseModels.Request) -> Observable<DeleteDetailContentUseCaseModels.Response> {
		return detailContentRepository.deleteDetailContent(request: request)
	}
}
