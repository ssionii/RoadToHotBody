//
//  RecordRepository.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/19.
//

import RxSwift

protocol RecordRepositoryProtocol {
	func fetchRecords(date: String) -> Single<[Content]>
	func saveRecord(date: String, text: String, type: ContentType, muscleIndex: Int?) -> Completable
	func updateRecord(index: Int, text: String) -> Completable
	func deleteRecord(index: Int) -> Completable
	func fetchPhotos() -> Single<[Photo]>
}
