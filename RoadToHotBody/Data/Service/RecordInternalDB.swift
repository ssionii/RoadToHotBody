//
//  RecordInternalDB.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/19.
//

import RxSwift
import RealmSwift

protocol RecordInternalDBProtocol {
	func fetchRecords(by date: String) -> Single<[Record]>
	func saveRecord(date: String, content: String, type: Int, trainingIndex: Int?) -> Completable
}

class RecordInternalDB: RecordInternalDBProtocol {

	private var realm: Realm?
	
	init() {
		do {
			realm = try Realm()
		} catch (let error) {
			print(error)
		}
	}
	
	func fetchRecords(by date: String) -> Single<[Record]> {
		return Single<[Record]>.create { single in
			if let realm = self.realm {
				
				let records = realm.objects(Record.self).filter("date == '\(date)'")
				let recordArray = Array(records)
				single(.success(recordArray))
	
			} else {
				single(.failure(RealmNotInitError(detailMessage: "")))
			}

			return Disposables.create { }
		}
	}
	
	func saveRecord(date: String, content: String, type: Int, trainingIndex: Int?) -> Completable {
		return Completable.create { completable in
			
			if let realm = self.realm {
				
				var index = 0
				if let last = realm.objects(Record.self).last {
					index = last.index + 1
				}
				
				let record = Record()
				record.index = index
				record.date = date
				record.content = content
				record.type = type
				
				if let trainingIndex = trainingIndex {
					record.trainingIndex = trainingIndex
				}
				
				do {
					try realm.write {
						realm.add(record)
						completable(.completed)
					}
				} catch (let error) {
					print(error)
				}
			} else {
				completable(.error(RealmNotInitError(detailMessage: "")))
			}

			return Disposables.create { }
		}
	}
}
