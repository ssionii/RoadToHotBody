//
//  DetailViewModel.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import RxSwift
import RxCocoa

class DetailViewModel {
	struct Input {
		var reloadView: Observable<Void>
	}
	
	struct Output {
		var muscleName: Driver<String>
		var contents: Observable<[Content]?>
	}
	
	// TODO: DI
	let fetchDetailContentsUseCase = FetchDetailContentsUseCase(repository: DetailContentRepository(dataSource: DetailContentDataSource()))
	
	private var muscle: Muscle
	
	init(muscle: Muscle) {
		self.muscle = muscle
	}
	
	func transform(input: Input) -> Output {
		
		let name = Observable.of(muscle.name)
			.asDriver(onErrorJustReturn: "")
		
		let contents = input.reloadView
			.do(onNext: {
				print("hello ~ 2")
			})
			.flatMap { _ -> Observable<FetchDetailContentsUseCaseModels.Response> in
				self.fetchDetailContentsUseCase.execute(
					request: FetchDetailContentsUseCaseModels.Request(trainingIndex: self.muscle.index)
				)
			}
			.map { response -> [Content]? in
				response.contents
			}
		
		return Output(muscleName: name, contents: contents)
	}
}
