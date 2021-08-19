//
//  RecordRepository.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/19.
//

import RxSwift

protocol RecordRepositoryProtocol {
	func fetchRecords(request: FetchRecordsUseCaseModels.Request) -> Observable<FetchRecordsUseCaseModels.Response>
	func saveRecord(request: SaveRecordUseCaseModels.Request) -> Observable<SaveRecordUseCaseModels.Response>
}
