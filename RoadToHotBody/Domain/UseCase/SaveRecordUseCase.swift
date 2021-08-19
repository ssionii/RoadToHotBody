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
	private let formatter = DateFormatter()
	
	init(repository: RecordRepositoryProtocol) {
		self.recordRepository = repository
		
		formatter.dateFormat = "yyyy-M-d"
	}
	
	func execute(request: SaveRecordUseCaseModels.Request) -> Observable<SaveRecordUseCaseModels.Response> {
		
		guard let _ = request.date else {
			let date = formatter.string(from: Date())
			let newRequest = SaveRecordUseCaseModels.Request(
				date: date, text: request.text, type: request.type, muscle: request.muscle)
			
			return recordRepository.saveRecord(request: newRequest)
		}
		
		return recordRepository.saveRecord(request: request)
	}
}
