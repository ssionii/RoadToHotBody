//
//  RecordDataSource.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/19.
//

import Foundation
import RxSwift
import RxCocoa

protocol RecordDataSourceProtocol {
	func fetchRecords(by date: String) -> Single<[Content]>
	func saveRecord(date: String, text: String, type: ContentType, muscleIndex: Int?) -> Completable
}

class RecordDataSource: RecordDataSourceProtocol {

	private let recordInternalDB = RecordInternalDB()

	func fetchRecords(by date: String) -> Single<[Content]> {
		return recordInternalDB.fetchRecords(by: date)
			.map { records -> [Content] in
				return records.map { record -> Content in
					Content(
						index: record.index,
						type: ContentType(rawValue: record.type) ?? .Memo,
						text: record.content
					)
				}
			}
	}
	
	func saveRecord(date: String, text: String, type: ContentType, muscleIndex: Int? = nil) -> Completable {
		return recordInternalDB.saveRecord(date: date, content: text, type: type.rawValue, trainingIndex: muscleIndex)
	}
}


