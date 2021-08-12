//
//  TrainingDetailCoreData.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/12.
//

import Foundation
import RxSwift
import CoreData

protocol TrainingDetailCoreDataProtocol {
	func fetchTrainingDetail() -> Single<[TrainingDetail]>
}

class TrainingDetailCoreData: TrainingDetailCoreDataProtocol {
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Model")
		container.loadPersistentStores { description, error in
			if let error = error {
				fatalError("Unable to load persistent stores :\(error)")
			}
		}
		return container
	}()
	
//	init(container: NSPersistentContainer) {
//		self.persistentContainer = container
//	}
	
	func fetchTrainingDetail() -> Single<[TrainingDetail]> {
		return Single<[TrainingDetail]>.create { single in
			
			do {
				if let trainingDetails = try self.persistentContainer.viewContext.fetch(TrainingDetail.fetchRequest()) as? [TrainingDetail] {
					single(.success(trainingDetails))
				} else {
					// FIXME: 여기 success로 넘겨주는게 맞나?
					single(.success([]))
				}
			} catch {
				single(.failure(TableNotFoundError(detailMessage: error.localizedDescription)))
			}
			
			return Disposables.create { }
		}
	}
	
	func writeTrainingDetail(content: String, date: Date) -> Completable {
		return Completable.create { completable in
			let entity = NSEntityDescription.entity(forEntityName: "", in: <#T##NSManagedObjectContext#>)
			let detail = NSManagedObject(entity: , insertInto: <#T##NSManagedObjectContext?#>)
			
		}
	}
}
