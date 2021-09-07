//
//  CalendarViewModel.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/17.
//

import RxSwift
import RxCocoa

struct DateRecord {
	var date: String
	var records: [Content]
}

class CalendarViewModel {
	struct Input {
		var currentPage: Observable<Date>
		var savePhoto: Observable<NSURL>
		var selectedDate: Observable<String>
	}
	
	struct Output {
		var dateRecords: Observable<[String : [Content]]>
		var photoSaved: Observable<Void>
	}
	
	private let recordRepo = RecordRepository(dataSource: RecordInternalDB())
	private var fetchMonthRecordsUseCase: FetchMonthRecordsUseCaseProtocol
	private var saveRecordUseCase: SaveRecordUseCaseProtocol
	
	private var currentYear: Int
	private var currentMonth: Int
	private var currentYearAndMonthChanged = PublishSubject<Void>()
	
	init() {
		fetchMonthRecordsUseCase = FetchMonthRecordsUseCase(repository: self.recordRepo)
		saveRecordUseCase = SaveRecordUseCase(repository: self.recordRepo)
		
		let date = Date()
		currentYear = Calendar.current.component(.year, from: date)
		currentMonth = Calendar.current.component(.month, from: date)
	}
	
	func transform(input: Input) -> Output {
		
//		let dateRecords = input.reloadView
//			.withLatestFrom(input.currentPage) { return ($0, $1) }
//			.map { (_, date) -> (Date, Date) in
//				return (date.startOfMonth, date.endOfMonth)
//			}.flatMap { start, end -> Observable<FetchMonthRecordsUseCaseModels.Response> in
//
//				return self.fetchMonthRecordsUseCase.execute(request: FetchMonthRecordsUseCaseModels.Request(startDate: start, endDate: end))
//			}.map { response -> [String : [Content]] in
//
//				var hashMap: [String : [Content]] = [:]
//
//				for dateRecord in response.dateRecords {
//					hashMap[dateRecord.date] = dateRecord.records
//				}
//
//				return hashMap
//			}
		
		
		let dateRecords = input.currentPage
			.map { date -> (Date, Date) in
				return (date.startOfMonth, date.endOfMonth)
			}.flatMap { start, end -> Observable<FetchMonthRecordsUseCaseModels.Response> in
				return self.fetchMonthRecordsUseCase.execute(request: FetchMonthRecordsUseCaseModels.Request(startDate: start, endDate: end))
			}.map { response -> [String : [Content]] in
				
				var hashMap: [String : [Content]] = [:]
				
				for dateRecord in response.dateRecords {
					hashMap[dateRecord.date] = dateRecord.records
				}
				
				return hashMap
			}
		
		let photoSaved = input.savePhoto
			.withLatestFrom(input.selectedDate) { return ($0, $1) }
			.flatMap { (url, date) -> Observable<SaveRecordUseCaseModels.Response> in
				return self.saveRecordUseCase.execute(
					request: SaveRecordUseCaseModels.Request(date: date, text: String(describing: url), type: .Photo, muscle: nil)
				)
			}
			.map { response -> Void in
				return ()
			}
		
		return Output(dateRecords: dateRecords, photoSaved: photoSaved)
	}
}
