//
//  MuscleDataSource.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import Foundation
import RxSwift

protocol MuscleDataSourceProtocol {
	func fetchMuscles() -> Single<[Muscle]>
}

class MuscleDataSource: MuscleDataSourceProtocol {
	
	private let trainingInternalDB = TrainingInternalDB()
	
	func fetchMuscles() -> Single<[Muscle]> {
		return trainingInternalDB.fetchTrainings()
			.map { (trainings) -> [Muscle] in
				return trainings.map { training -> Muscle in
					training.toMuscle()
				}
			}
	}	
}
