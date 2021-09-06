//
//  FetchMonthRecordsUseCase.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/09/06.
//

import Foundation
import RxSwift

protocol FetchMonthRecordsUseCaseProtocol {
	func execute(request: FetchMonthRecordsUseCaseModels.Request) -> Observable<FetchMonthRecordsUseCaseModels.Response>
}

struct FetchMonthRecordsUseCaseModels {
	struct Request {
		var startDate: Date
		var endDate: Date
	}
	
	struct Response {
		var dateRecords: [DateRecord]
	}
}

class FetchMonthRecordsUseCase: FetchMonthRecordsUseCaseProtocol {
	
	private let recordRepository: RecordRepositoryProtocol
	
	init(repository: RecordRepositoryProtocol) {
		self.recordRepository = repository
	}
	
	func execute(request: FetchMonthRecordsUseCaseModels.Request) -> Observable<FetchMonthRecordsUseCaseModels.Response> {
		return recordRepository.fetchMonthRecords(startDate: request.startDate, endDate: request.endDate)
			.asObservable()
			.map { dateRecords -> FetchMonthRecordsUseCaseModels.Response in
				return FetchMonthRecordsUseCaseModels.Response(
					dateRecords: dateRecords
				)
			}
	}
	
	
}


