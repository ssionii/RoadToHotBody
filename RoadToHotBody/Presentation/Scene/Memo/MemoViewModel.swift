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
		var text: Observable<String?>
	}
	
	struct Output {
		var text: Driver<String>?
		var isSaved: Observable<Bool>
	}
	
	private let fetchDetailContentUseCase = FetchDetailContentUseCase(repository:  DetailContentRepository())
	private let saveDetailContentUseCase = SaveDetailContentUseCase(repository:  DetailContentRepository())
	
	var memoType: MemoType
	private var content: Content?
	
	init(memoType: MemoType, content: Content?) {
		self.memoType = memoType
		self.content = content
	}
	
	func transfrom(input: Input) -> Output {
		
		let isSaved = input.confirmButtonClicked
			.withLatestFrom(input.text)
			.compactMap { $0 }
			.flatMap({ text -> Observable<SaveDetailContentUseCaseModels.Response> in
				self.saveDetailContentUseCase.execute(
					request: SaveDetailContentUseCaseModels.Request(index: self.content?.index, text: text)
				)
			})
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
			
			return Output(text: text, isSaved: isSaved)
		case .Write:
			return Output(text: nil, isSaved: isSaved)
		}
	}
}
