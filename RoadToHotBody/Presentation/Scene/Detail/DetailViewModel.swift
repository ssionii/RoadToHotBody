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
		
	}
	
	struct Output {
		var muscleName: Driver<String>
		var contents: Observable<[Content]?>
	}
	
	// TODO: DI
	let fetchDetailContentsUseCase = FetchDetailContentUseCase(repository: ContentRepository())
	
	private var muscleName: String
	
	init(muscleName: String) {
		self.muscleName = muscleName
	}
	
	func transform(input: Input) -> Output {
		
		let name = Observable.of(muscleName)
			.asDriver(onErrorJustReturn: "")
		
		let contents =  self.fetchDetailContentsUseCase.execute(
			request: FetchDetailContentsUseCaseModels.Request(muscleName: self.muscleName)
		)
		.map { response -> [Content]? in
			response.contents
		}
		
		return Output(muscleName: name, contents: contents)
	}
}
