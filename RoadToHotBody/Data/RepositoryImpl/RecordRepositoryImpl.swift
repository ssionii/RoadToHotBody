//
//  RecordRepositoryImpl.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/19.
//

import RxSwift

class RecordRepository: RecordRepositoryProtocol {
	
	private let recordDataSource: RecordDataSourceProtocol
	
	init(dataSource: RecordDataSourceProtocol) {
		self.recordDataSource = dataSource
	}
	
	func fetchRecords(request: FetchRecordsUseCaseModels.Request) -> Observable<FetchRecordsUseCaseModels.Response> {
		return recordDataSource.fetchRecords(by: request.date)
			.asObservable()
			.map { contents -> FetchRecordsUseCaseModels.Response in
				return FetchRecordsUseCaseModels.Response(records: contents)
			}
	}
	
	
	func saveRecord(request: SaveRecordUseCaseModels.Request) -> Observable<SaveRecordUseCaseModels.Response> {
		guard let date = request.date else { return .never() }
		return recordDataSource.saveRecord(date: date, text: request.text, type: request.type, muscleIndex: request.muscle?.index)
			.andThen(Observable.of(SaveRecordUseCaseModels.Response()))
	}
}
