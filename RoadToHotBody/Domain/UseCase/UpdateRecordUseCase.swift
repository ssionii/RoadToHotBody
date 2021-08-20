//
//  UpdateRecordUseCase.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/20.
//

import RxSwift

protocol UpdateRecordUseCaseProtocol {
	func execute(request: UpdateRecordUseCaseModels.Request) -> Observable<UpdateRecordUseCaseModels.Response>

}

struct UpdateRecordUseCaseModels {
	struct Request {
		var index: Int
		var text: String
	}
	
	struct Response {
		
	}
}

class UpdateRecordUseCase: UpdateRecordUseCaseProtocol {
	
	private let recordRepository: RecordRepositoryProtocol
	
	init(repository: RecordRepositoryProtocol) {
		self.recordRepository = repository
	}
	
	func execute(request: UpdateRecordUseCaseModels.Request) -> Observable<UpdateRecordUseCaseModels.Response> {
		return recordRepository.updateRecord(index: request.index, text: request.text)
			.andThen(Observable.just(UpdateRecordUseCaseModels.Response()))
	}
}
