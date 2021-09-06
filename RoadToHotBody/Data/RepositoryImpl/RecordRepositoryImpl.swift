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
					return record.toContent()
				}
			}
	}
	
	func fetchMonthRecords(startDate: Date, endDate: Date) -> Single<[DateRecord]> {
		return recordDB.fetchMonthRecords(startDate: startDate, endDate: endDate)
			.map { dateRecordDTOs -> [DateRecord] in
				dateRecordDTOs.map { dateRecordDTO -> DateRecord in
					let records = dateRecordDTO.records.map { record -> Content in
						return record.toContent()
					}
					return DateRecord(date: dateRecordDTO.date, records: records)
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
	
	func fetchPhotos() -> Single<[Photo]> {
		return recordDB.fetchPhotos()
			.map { records -> [Photo] in
				records.map { record -> Photo in
					return Photo(index: record.index, urlString: record.content, date: record.date)
				}
			}
	}
}
