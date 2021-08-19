//
//  FetchRecordsUseCase.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/19.
//

import RxSwift

protocol FetchRecordsUseCaseProtocol {
	func execute(request: FetchRecordsUseCaseModels.Request) -> Observable<FetchRecordsUseCaseModels.Response>
}

struct FetchRecordsUseCaseModels {
	struct Request {
		var date: String
	}
	
	struct Response {
		var records: [Content]
	}
}

class FetchRecordsUseCase: FetchRecordsUseCaseProtocol {
	
	private let recordRepository: RecordRepositoryProtocol
	
	init(repository: RecordRepositoryProtocol) {
		self.recordRepository = repository
	}
	
	func execute(request: FetchRecordsUseCaseModels.Request) -> Observable<FetchRecordsUseCaseModels.Response> {
		return recordRepository.fetchRecords(request: request)
	}
}
