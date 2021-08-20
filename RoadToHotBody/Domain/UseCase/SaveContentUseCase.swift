//
//  SaveDetailContent.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/11.
//

import RxSwift

protocol SaveContentUseCaseProtocol {
	func execute(
		request: SaveContentUseCaseModels.Request
	) -> Observable<SaveContentUseCaseModels.Response>
}

struct SaveContentUseCaseModels {
	struct Request {
		var muscleIndex: Int
		var text: String
		var type: ContentType
	}
	
	struct Response {
		
	}
}

class SaveContentUseCase: SaveContentUseCaseProtocol {
	
	private let detailContentRepository: DetailContentRepositoryProtocol
	
	init(repository: DetailContentRepositoryProtocol) {
		self.detailContentRepository = repository
	}
	
	func execute(request: SaveContentUseCaseModels.Request) -> Observable<SaveContentUseCaseModels.Response> {
		return detailContentRepository.saveDetailContent(muscleIndex: request.muscleIndex, text: request.text, type: request.type)
			.andThen(Observable.just(SaveContentUseCaseModels.Response()))
	}
}
