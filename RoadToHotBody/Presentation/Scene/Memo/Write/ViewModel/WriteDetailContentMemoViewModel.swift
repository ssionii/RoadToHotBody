//
//  WriteDetailContentMemoViewModel.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/20.
//

import RxSwift
import RxCocoa

class WriteDetailContentViewModel: WriteMemoViewModel {
	
	private let saveContentUseCase = SaveContentUseCase(repository: DetailContentRepository(dataSource: TrainingDetailInternalDB()))
	
	override func transform(input: WriteMemoViewModel.Input) -> WriteMemoViewModel.Output {
		
		guard let muscle = super.muscle else { return super.transform(input: input) }
		
		let isSaved = input.confirmButtonClicked
			.withLatestFrom(input.text)
			.compactMap { $0 }
			.flatMap({ text -> Observable<SaveContentUseCaseModels.Response> in
				self.saveContentUseCase.execute(
					request: SaveContentUseCaseModels.Request(
						muscleIndex: muscle.index,
						text: text,
						type: .Memo
					)
				)
			})
			.map({ response -> Void in
				return ()
			})
		
		return Output(isSaved: isSaved, title: Driver.just(""))
	}
	
}
