//
//  SaveDetailContent.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/11.
//

import RxSwift

protocol SaveDetailContentUseCaseProtocol {
	func execute(
		request: SaveDetailContentUseCaseModels.Request
	) -> Observable<SaveDetailContentUseCaseModels.Response>
}

struct SaveDetailContentUseCaseModels {
	struct Request {
		var type: ContentType
		var text: String
		var muscleIndex: Int
	}
	
	struct Response {
		var isSuccess: Bool
	}
}

class SaveDetailContentUseCase: SaveDetailContentUseCaseProtocol {
	
	private let detailContentRepository: DetailContentRepositoryProtocol
	
	init(repository: DetailContentRepositoryProtocol) {
		self.detailContentRepository = repository
	}
	
	func execute(request: SaveDetailContentUseCaseModels.Request) -> Observable<SaveDetailContentUseCaseModels.Response> {
		return detailContentRepository.saveDetailContent(request: request)
	}
}
