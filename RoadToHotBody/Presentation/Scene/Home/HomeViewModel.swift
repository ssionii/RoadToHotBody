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
		
	}
	
	struct Output {
		var muscles: Observable<[Muscle]>
	}
	
	let fetchMusclesUseCase = FetchMuscleUseCase(repository: MuscleRepository(dataSource: MuscleDataSource()))
	
	func transform(input: Input) -> Output {
		let muscles = fetchMusclesUseCase.execute(request: FetchMuscleUseCaseModels.Request())
			.map { response -> [Muscle] in
				response.muscles
			}
		
		return Output(muscles: muscles)
	}
}
