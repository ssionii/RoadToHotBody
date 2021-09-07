//
//  RecordInternalDB.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/19.
//

import RxSwift
import RealmSwift

protocol RecordInternalDBProtocol {
	func fetchRecords(date: String) -> Single<[Record]>
	func fetchMonthRecords(startDate: Date, endDate: Date) -> Single<[DateRecordDTO]>
	func saveRecord(date: String, content: String, type: Int, trainingIndex: Int?) -> Completable
	func updateRecord(index: Int, content: String) -> Completable
	func deleteRecord(index: Int) -> Completable
	func fetchPhotos() -> Single<[Record]>
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
	
	func fetchRecords(date: String) -> Single<[Record]> {
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
	
	func fetchMonthRecords(startDate: Date, endDate: Date) -> Single<[DateRecordDTO]> {
		return Single<[DateRecordDTO]>.create { single in
			if let realm = self.realm {
				
				var recordArray: [DateRecordDTO] = []
				
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "yyyy-MM"
				
				let yearAndMonth = dateFormatter.string(from: endDate)
				for day in startDate.day ... endDate.day {
					let convertedDay = String(day).count == 1 ? "0\(day)" : String(day)
					let dateString = "\(yearAndMonth)-\(convertedDay)"
		
					let records = realm.objects(Record.self).filter("date == '\(dateString)'")
					let dateRecord = DateRecordDTO(date: dateString, records: Array(records))
					recordArray.append(dateRecord)
				}
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
	
	func updateRecord(index: Int, content: String) -> Completable {
		return Completable.create { completable in
			
			if let realm = self.realm {
				
				guard let record = realm.object(ofType: Record.self, forPrimaryKey: index) else {
					completable(.error(RecordNotFoundError(detailMessage: "")))
					return Disposables.create { }
				}
				
				do {
					try realm.write {
						record.content = content
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
	
	func deleteRecord(index: Int) -> Completable {
		return Completable.create { completable in
			
			if let realm = self.realm {
				
				guard let record = realm.object(ofType: Record.self, forPrimaryKey: index) else {
					completable(.error(RecordNotFoundError(detailMessage: "primaryKey: \(index)")))
					return Disposables.create { }
				}
				
				do {
					try realm.write {
						realm.delete(record)
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
	
	func fetchPhotos() -> Single<[Record]> {
		return Single<[Record]>.create { single in
			if let realm = self.realm {
				
				let photoRecords = realm.objects(Record.self).filter("type == \(ContentType.Photo.rawValue)")
				let photoArray = Array(photoRecords)
				single(.success(photoArray))
	
			} else {
				single(.failure(RealmNotInitError(detailMessage: "")))
			}

			return Disposables.create { }
		}
	}
	
}
