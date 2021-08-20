//
//  ReadRecordMemoViewModel.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/20.
//

import RxSwift

class ReadRecordMemoViewModel: ReadMemoViewModel {
	
	private let updateRecordUseCase: UpdateRecordUseCaseProtocol
	private let deleteRecordUseCase: DeleteRecordUseCaseProtocol
	
	override init(content: Content) {
		
		let recordRepository = RecordRepository(dataSource: RecordInternalDB())
		updateRecordUseCase = UpdateRecordUseCase(repository: recordRepository)
		deleteRecordUseCase = DeleteRecordUseCase(repository: recordRepository)
		
		super.init(content: content)
	}
	
	override func transform(input: ReadMemoViewModel.Input) -> ReadMemoViewModel.Output {
		
		let superOutput = super.transform(input: input)
		
		let isUpdated = input.confirmButtonClicked
			.withLatestFrom(input.text)
			.compactMap { $0 }
			.flatMap { text -> Observable<UpdateRecordUseCaseModels.Response> in
				return self.updateRecordUseCase.execute(
					request: UpdateRecordUseCaseModels.Request(
						index: self.content.index,
						text: text
					)
				)
			}
			.map { _ -> Void in
				return ()
			}
		
		let isDeleted = input.deleteButtonClicked
			.flatMap { _ -> Observable<DeleteRecordUseCaseModels.Response> in
				self.deleteRecordUseCase.execute(
					request: DeleteRecordUseCaseModels.Request(index: self.content.index)
				)
			}
			.map { response -> Void in
				return ()
			}
		
		return Output(text: superOutput.text, isEditType: superOutput.isEditType, isUpdated: isUpdated, isDeleted: isDeleted)
	}
}
