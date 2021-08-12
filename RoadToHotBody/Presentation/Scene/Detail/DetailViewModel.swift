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
	let fetchDetailContentsUseCase = FetchDetailContentsUseCase(repository: TrainingDetailRepository(dataSource: TrainingDetailDataSource(trainingDetailCoreData: TrainingDetailCoreData())))
	
	private var muscleName: String
	
	init(muscleName: String) {
		self.muscleName = muscleName
	}
	
	func transform(input: Input) -> Output {
		
		let name = Observable.of(muscleName)
			.asDriver(onErrorJustReturn: "")
		
		let contents = input.reloadView
			.flatMap { _ -> Observable<FetchDetailContentsUseCaseModels.Response> in
				self.fetchDetailContentsUseCase.execute(
					request: FetchDetailContentsUseCaseModels.Request(muscleName: self.muscleName)
				)
			}
			.map { response -> [Content]? in
				response.contents
			}
		
		return Output(muscleName: name, contents: contents)
	}
}
