//
//  ReadDetailContentMemoViewModel.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/20.
//

import RxSwift

class ReadDetailContentMemoViewModel: ReadMemoViewModel {
	private let updateDetailContentUseCase: UpdateDetailContentUseCaseProtocol
	private let deleteDetailContentUseCase: DeleteDetailContentUseCaseProtocol
	
	override init(content: Content) {
		
		let detailContentRepository = DetailContentRepository(dataSource: TrainingDetailInternalDB())
		updateDetailContentUseCase = UpdateDetailContentUseCase(repository: detailContentRepository)
		deleteDetailContentUseCase = DeleteDetailContentUseCase(repository: detailContentRepository)
		
		super.init(content: content)
	}
	
	override func transform(input: ReadMemoViewModel.Input) -> ReadMemoViewModel.Output {
		
		let superOutput = super.transform(input: input)
		
		let isUpdated = input.confirmButtonClicked
			.withLatestFrom(input.text)
			.compactMap { $0 }
			.flatMap { text -> Observable<UpdateDetailContentUseCaseModels.Response> in
				return self.updateDetailContentUseCase.execute(
					request: UpdateDetailContentUseCaseModels.Request(
						index: self.content.index,
						text: text
					)
				)
			}
			.map { _ -> Void in
				return ()
			}
		
		let isDeleted = input.deleteButtonClicked
			.flatMap { _ -> Observable<DeleteDetailContentUseCaseModels.Response> in
				self.deleteDetailContentUseCase.execute(
					request: DeleteDetailContentUseCaseModels.Request(index: self.content.index)
				)
			}
			.map { response -> Void in
				return ()
			}
		
		return Output(text: superOutput.text, isEditType: superOutput.isEditType, isUpdated: isUpdated, isDeleted: isDeleted)
	}
}
