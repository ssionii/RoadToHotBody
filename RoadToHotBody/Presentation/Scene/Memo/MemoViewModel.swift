//
//  MemoViewModel.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/11.
//

import RxSwift
import RxCocoa

enum MemoType {
	case Read
	case Write
}

class MemoViewModel {
	struct Input {
		var confirmButtonClicked: Observable<Void>
		var deleteButtonClicked: Observable<Void>
		var text: Observable<String?>
	}
	
	struct Output {
		var text: Driver<String>?
		var isSaved: Observable<Bool>
		var isDeleted: Observable<Bool>
	}
	
	private let fetchDetailContentUseCase = FetchDetailContentUseCase(repository: DetailContentRepository(dataSource: DetailContentDataSource()))
	private let saveDetailContentUseCase = SaveDetailContentUseCase(repository: DetailContentRepository(dataSource: DetailContentDataSource()))
	private let deleteDetailContentUseCase = DeleteDetailContentUseCase(repository: DetailContentRepository(dataSource: DetailContentDataSource()))
	
	var memoType: MemoType
	private var content: Content?
	private var muscle: Muscle?
	
	init(memoType: MemoType, content: Content?, muscle: Muscle?) {
		self.memoType = memoType
		self.content = content
		self.muscle = muscle
	}
	
	func transfrom(input: Input) -> Output {
		
		// TODO: muscle 없을 때 처리
		let isSaved = input.confirmButtonClicked
			.withLatestFrom(input.text)
			.compactMap { $0 }
			.flatMap({ text -> Observable<SaveDetailContentUseCaseModels.Response> in
				self.saveDetailContentUseCase.execute(
					request: SaveDetailContentUseCaseModels.Request(index: self.content?.index, type: .Memo, text: text, muscleIndex: self.muscle?.index ?? 0)
				)
			})
			.map { response -> Bool in
				return response.isSuccess
			}
		
		let isDeleted = input.deleteButtonClicked
			.flatMap { _ -> Observable<DeleteDetailContentUseCaseModels.Response> in
				self.deleteDetailContentUseCase.execute(
					request: DeleteDetailContentUseCaseModels.Request(index: self.content?.index ?? 0)
				)
			}
			.map { response -> Bool in
				return response.isSuccess
			}
		
		switch memoType {
		case .Read:
			let text = Observable.of(self.content)
				.compactMap { $0 }
				.map { content -> String? in
					content.text
				}
				.compactMap { $0 }
				.asDriver(onErrorJustReturn: "")
			
			return Output(text: text, isSaved: isSaved, isDeleted: isDeleted)
		case .Write:
			return Output(text: nil, isSaved: isSaved, isDeleted: isDeleted)
		}
	}
}
