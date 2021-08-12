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
	case Edit
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
	
	let memoType: MemoType
	private var index: Int?
	
	init(memoType: MemoType, contentIndex: Int?) {
		self.memoType = memoType
		self.index = contentIndex
	}
	
	func transfrom(input: Input) -> Output {
		
		switch memoType {
		case .Read:
			let text = self.text(input: input)
			let isSaved = self.isSaved(input: input)
			
			return Output(text: text, isSaved: isSaved)
		case .Write:
			let isSaved = self.isSaved(input: input)
			
			return Output(text: nil, isSaved: isSaved)
		case .Edit:
			let text = self.text(input: input)
			let isSaved = self.isSaved(input: input)
		
			return Output(text: text, isSaved: isSaved)
		}
	}
	
	private func isSaved(input: Input) -> Observable<Bool> {
		return input.confirmButtonClicked
			.withLatestFrom(input.text)
			.compactMap { $0 }
			.flatMap({ text -> Observable<SaveDetailContentUseCaseModels.Response> in
				self.saveDetailContentUseCase.execute(
					request: SaveDetailContentUseCaseModels.Request(text: text)
				)
			})
			.map { response -> Bool in
				return response.isSuccess
			}
	}
	
	private func text(input: Input) -> Driver<String> {
		guard let index = self.index
		else {
			print("memo index 없음")
			return Driver.of("")
		}
		
		return fetchDetailContentUseCase.execute(
			request: FetchDetailContentUseCaseModels.Request(
				index: index
			)
		)
		.map { response -> String in
			self.index = response.content.index
			return response.content.text ?? ""
		}
		.asDriver(onErrorJustReturn: "")
	}
}
