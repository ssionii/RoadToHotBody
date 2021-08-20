//
//  TrainingDetailCoreData.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/12.
//

import RxSwift
import RealmSwift

protocol TrainingDetailInternalDBProtocol {
	func fetchTrainingDetails(trainingIndex: Int) -> Single<[TrainingDetail]>
	func saveTrainingDetail(trainingIndex: Int, content: String, type: Int) -> Completable
    func updateTrainingDetail(index: Int, content: String) -> Completable
	func deleteTrainingDetail(index: Int) -> Completable
}

class TrainingDetailInternalDB: TrainingDetailInternalDBProtocol {
	
	private var realm: Realm?
	
	init() {
		do {
			realm = try Realm()
		} catch (let error) {
            print(error)
		}
	}
	
	func fetchTrainingDetails(trainingIndex: Int) -> Single<[TrainingDetail]>{
		
		return Single<[TrainingDetail]>.create { single in
			if let realm = self.realm {
				
				let trainingDetails = realm.objects(TrainingDetail.self).filter("trainingIndex == \(trainingIndex)")
				let details = Array(trainingDetails)
				single(.success(details))
	
			} else {
				single(.failure(RealmNotInitError(detailMessage: "")))
			}

			return Disposables.create { }
		}
	}
	
	func saveTrainingDetail(trainingIndex: Int, content: String, type: Int) -> Completable {
		return Completable.create { completable in
			
			if let realm = self.realm {
				
				var index = 0
				if let last = realm.objects(TrainingDetail.self).last {
					index = last.index + 1
				}
				
				let detail = TrainingDetail()
				detail.type = type
				detail.content = content
				detail.date = Date()
				detail.trainingIndex = trainingIndex
				detail.index = index
				
				do {
					try realm.write {
						realm.add(detail)
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
    
    func updateTrainingDetail(index: Int, content: String) -> Completable {
        return Completable.create { completable in
            
            if let realm = self.realm {
                
                guard let detail = realm.object(ofType: TrainingDetail.self, forPrimaryKey: index) else {
                    completable(.error(TrainingDetailNotFoundError(detailMessage: "")))
                    return Disposables.create { }
                }
                
                do {
                    try realm.write {
                        detail.content = content
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
	
	func deleteTrainingDetail(index: Int) -> Completable {
		return Completable.create { completable in
			
			if let realm = self.realm {
				
				guard let detail = realm.object(ofType: TrainingDetail.self, forPrimaryKey: index) else {
					completable(.error(TrainingDetailNotFoundError(detailMessage: "")))
					return Disposables.create { }
				}
				
				do {
					try realm.write {
						realm.delete(detail)
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
