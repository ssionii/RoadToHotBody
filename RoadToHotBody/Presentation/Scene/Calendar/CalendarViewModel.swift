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
		var selectedDate: Observable<String>
		var addedPhotoRecordURL: Observable<NSURL>
		var currentPage: Observable<Date>
	}
	
	struct Output {
		var dateRecords: Observable<[String : [Content]]>
		var isPhotoAdded: Observable<Void>
	}
	
	private let fetchMonthRecordsUseCase = FetchMonthRecordsUseCase(repository: RecordRepository(dataSource: RecordInternalDB()))
	private let saveRecordUseCase = SaveRecordUseCase(repository: RecordRepository(dataSource: RecordInternalDB()))
	
	private var currentYear: Int
	private var currentMonth: Int
	private var currentYearAndMonthChanged = PublishSubject<Void>()
	
	init() {
		let date = Date()
		currentYear = Calendar.current.component(.year, from: date)
		currentMonth = Calendar.current.component(.month, from: date)
	}
	
	func transform(input: Input) -> Output {
		
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
			
		let isPhotoAdded = input.addedPhotoRecordURL
			.withLatestFrom(input.selectedDate) { return ($0, $1) }
			.flatMap { url, date -> Observable<SaveRecordUseCaseModels.Response> in
				return self.saveRecordUseCase.execute(
					request: SaveRecordUseCaseModels.Request(
						date: date,
						text: String(describing: url),
						type: .Photo,
						muscle: nil
					)
				)
			}
			.map { response -> Void in
				return ()
			}
		
		return Output(dateRecords: dateRecords, isPhotoAdded: isPhotoAdded)
	}
}
