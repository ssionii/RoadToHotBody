//
//  FetchMusclesUseCase.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import RxSwift

protocol FetchMuscleUseCaseProtocol {
	func execute(
		request: FetchMuscleUseCaseModels.Request
	) -> Observable<FetchMuscleUseCaseModels.Response>
}

struct FetchMuscleUseCaseModels {
	struct Request {
		var direction: Direction
	}
	
	struct Response {
		var muscles: [Muscle]
	}
}

class FetchMuscleUseCase: FetchMuscleUseCaseProtocol {
	
	private let muscleRepository: MuscleRepositoryProtocol
	
	init(repository: MuscleRepositoryProtocol) {
		self.muscleRepository = repository
	}
	
	func execute(
		request: FetchMuscleUseCaseModels.Request
	) -> Observable<FetchMuscleUseCaseModels.Response> {
		return muscleRepository.fetchMuscles(direction: request.direction)
			.asObservable()
			.map { muscles -> FetchMuscleUseCaseModels.Response in
				return FetchMuscleUseCaseModels.Response(muscles: muscles)
			}
	}
}
