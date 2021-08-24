//
//  RecordRepositoryImpl.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/19.
//

import RxSwift

class RecordRepository: RecordRepositoryProtocol {
	
	private let recordDB: RecordInternalDBProtocol
	
	init(dataSource: RecordInternalDBProtocol) {
		self.recordDB = dataSource
	}
	
	func fetchRecords(date: String) -> Single<[Content]> {
		return recordDB.fetchRecords(date: date)
			.map { records -> [Content] in
				records.map { record -> Content in
					return Content(
						index: record.index,
						type: ContentType.init(rawValue: record.type) ?? .Memo,
						text: record.content
					)
				}
			}
	}
	
	func saveRecord(date: String, text: String, type: ContentType, muscleIndex: Int?) -> Completable {
		return recordDB.saveRecord(date: date, content: text, type: type.rawValue, trainingIndex: muscleIndex)
	}
	
	func updateRecord(index: Int, text: String) -> Completable {
		return recordDB.updateRecord(index: index, content: text)
	}
	
	func deleteRecord(index: Int) -> Completable {
		return recordDB.deleteRecord(index: index)
	}
	
	func fetchPhotos() -> Single<[String]> {
		return recordDB.fetchPhotos()
	}
}
