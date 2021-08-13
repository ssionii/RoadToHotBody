//
//  MuscleRepositoryImpl.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import RxSwift

class MuscleRepository: MuscleRepositoryProtocol {
	
	private let muscleDataSource: MuscleDataSourceProtocol
	
	init(dataSource: MuscleDataSourceProtocol) {
		self.muscleDataSource = dataSource
	}
	
	func fetchMuscles(
		request: FetchMuscleUseCaseModels.Request
	) -> Observable<FetchMuscleUseCaseModels.Response> {
		
		return muscleDataSource.fetchMuscles()
			.asObservable().map { muscles -> FetchMuscleUseCaseModels.Response in
				if muscles.isEmpty {
					throw MusclesEmptyError(detailMessage: "")
				}
				return FetchMuscleUseCaseModels.Response(muscles: muscles)
			}
	}
}
