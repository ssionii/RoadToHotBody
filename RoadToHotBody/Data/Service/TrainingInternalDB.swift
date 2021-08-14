//
//  TrainingInternalDB.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import RxSwift
import RealmSwift

protocol TrainingInternalDBProtocol {
	func fetchTrainings() -> Single<[Training]>
}

class TrainingInternalDB: TrainingInternalDBProtocol {
    
	func fetchTrainings() -> Single<[Training]> {
		return Single<[Training]>.create { single in
			
			guard let path =  Bundle.main.path(forResource: "training", ofType: "json") else {
				single(.failure(JsonNotFoundError(detailMessage: "")))
				return Disposables.create { }
			}
			
			do {
				guard let data = try String(contentsOfFile: path).data(using: .utf8) else {
					single(.failure(TableNotFoundError(detailMessage: "")))
					return Disposables.create {}
				}
				
				let json = try JSONDecoder().decode(TrainingJson.self, from: data)
				single(.success(json.training))
				
			} catch (let error) {
				// TODO: error 처리
				print(error)
			}
			
			return Disposables.create { }
		}
	}
}
