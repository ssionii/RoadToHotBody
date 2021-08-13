//
//  HomeViewModel.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import RxSwift
import RxCocoa

class HomeViewModel {
	struct Input {
		var changeDirection: Observable<Void>
	}
	
	struct Output {
		var muscles: Observable<[Muscle]>
	}
	
	let fetchMusclesUseCase = FetchMuscleUseCase(repository: MuscleRepository(dataSource: MuscleDataSource()))
	
	private var direction = Direction.Front
	
	func transform(input: Input) -> Output {
	
		let muscles = input.changeDirection
			.flatMap { () -> Observable<FetchMuscleUseCaseModels.Response> in
				
				if self.direction == Direction.Front {
					self.direction = Direction.Back
				} else {
					self.direction = Direction.Front
				}
				
				return self.fetchMusclesUseCase.execute(
					request: FetchMuscleUseCaseModels.Request(direction: self.direction)
				)
			}
			.map { response -> [Muscle] in
				return response.muscles
			}
		
		return Output(muscles: muscles)
	}
}
