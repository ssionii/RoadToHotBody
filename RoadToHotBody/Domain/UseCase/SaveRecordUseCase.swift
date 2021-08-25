//
//  SaveRecordUseCase.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/19.
//

import RxSwift

protocol SaveRecordUseCaseProtocol {
	func execute(request: SaveRecordUseCaseModels.Request) -> Observable<SaveRecordUseCaseModels.Response>
}

struct SaveRecordUseCaseModels {
	struct Request {
		var date: String?
		var text: String
		var type: ContentType
		var muscle: Muscle? = nil
	}
	
	struct Response {
		
	}
}

class SaveRecordUseCase: SaveRecordUseCaseProtocol {
	
	private let recordRepository: RecordRepositoryProtocol
	private var formatter = DateFormatter()
	
	init(repository: RecordRepositoryProtocol) {
		self.recordRepository = repository
		
		formatter.dateFormat = "yyyy-MM-dd"
	}
	
	func execute(request: SaveRecordUseCaseModels.Request) -> Observable<SaveRecordUseCaseModels.Response> {
		
		guard let date = request.date else {
			let today = formatter.string(from: Date())
			return recordRepository.saveRecord(date: today, text: request.text, type: request.type, muscleIndex: request.muscle?.index)
				.andThen(Observable.just(SaveRecordUseCaseModels.Response()))
		}
		
		return recordRepository.saveRecord(date: date, text: request.text, type: request.type, muscleIndex: request.muscle?.index)
			.andThen(Observable.just(SaveRecordUseCaseModels.Response()))
	}
}
