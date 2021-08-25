//
//  WriteRecordMemoViewModel.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/20.
//

import RxSwift

class WriteRecordMemoViewModel: WriteMemoViewModel {
	
	private let saveRecordUseCase = SaveRecordUseCase(repository: RecordRepository(dataSource: RecordInternalDB()))
	
	override func transform(input: WriteMemoViewModel.Input) -> WriteMemoViewModel.Output {
		
		guard let date = super.date else { return super.transform(input: input) }
		
		let isSaved = input.confirmButtonClicked
			.withLatestFrom(input.text)
			.compactMap { $0 }
			.flatMap { text -> Observable<SaveRecordUseCaseModels.Response> in
				self.saveRecordUseCase.execute(
					request: SaveRecordUseCaseModels.Request(date: date, text: text, type: .Memo, muscle: nil)
				)
			}
			.map({ response -> Void in
				return ()
			})
		
		let title = Observable.just(DateHelper.dateTitle(date: date, dateFormat: "M월 d일 EEEE"))
			.asDriver(onErrorJustReturn: "")
		
		return Output(isSaved: isSaved, title: title)
	}
}
