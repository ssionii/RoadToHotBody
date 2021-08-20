//
//  DeleteRecordUseCase.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/20.
//

import RxSwift

protocol DeleteRecordUseCaseProtocol {
	func execute(request: DeleteRecordUseCaseModels.Request) -> Observable<DeleteRecordUseCaseModels.Response>
}

struct DeleteRecordUseCaseModels {
	struct Request {
		var index: Int
	}
	
	struct Response {
		
	}
}

class DeleteRecordUseCase: DeleteRecordUseCaseProtocol {
	
	private let recordRepository: RecordRepositoryProtocol
	
	init(repository: RecordRepositoryProtocol) {
		self.recordRepository = repository
	}
	
	func execute(request: DeleteRecordUseCaseModels.Request) -> Observable<DeleteRecordUseCaseModels.Response> {
		return recordRepository.deleteRecord(index: request.index)
			.andThen(Observable.just(DeleteRecordUseCaseModels.Response()))
	}
}
