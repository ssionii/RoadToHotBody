//
//  DayViewModel.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/19.
//

import UIKit
import RxSwift
import RxCocoa

class DayViewModel {
	struct Input {
		var viewLoaded: Observable<Void>
	}
	
	struct Output {
		var textColor: Observable<UIColor>
		var dayString: Driver<String>
		var hasRecord: Observable<(Bool, Bool, Bool)>?
	}
	
	private let fetchRecordsUseCase = FetchRecordsUseCase(repository: RecordRepository(dataSource: RecordDataSource()))
	
	private let calendarDate: CalendarDate
	private let date: Date
	private let formatter: DateFormatter
	
	var records: [Content]?
	
	init(calendarDate: CalendarDate) {
		
		self.calendarDate = calendarDate
		
		date = Date()
		formatter = DateFormatter()
		formatter.dateFormat = "yyyy-M-d"
	}
	
	func transform(input: Input) -> Output {
		
		var textColor: Observable<UIColor>
		
		if isToday(dateString: calendarDate.date ?? "") {
			textColor = Observable.just(UIColor.red)
		} else {
			if calendarDate.isThisMonth {
				textColor = Observable.just(UIColor.black)
			} else {
				textColor = Observable.just(UIColor.lightGray)
			}
		}

		let dayString = Observable.just(calendarDate.dayString)
			.asDriver(onErrorJustReturn: "")
		
		guard let date = calendarDate.date else {
			return Output(
				textColor: textColor,
				dayString: dayString,
				hasRecord: Observable.of((false, false, false))
			)
		}
		
		let records = input.viewLoaded
			.flatMap { _ -> Observable<FetchRecordsUseCaseModels.Response> in
				self.fetchRecordsUseCase.execute(
					request: FetchRecordsUseCaseModels.Request(date: date)
				)
			}
			.map { response -> [Content] in
				self.records = response.records
				print(response.records)
				return response.records
			}
			.share()
		
		let hasRecord = records
			.map { contents -> (Bool, Bool, Bool) in
				return (
					contents.contains { $0.type == .Exercise } ,
					contents.contains { $0.type == .Memo },
					contents.contains { $0.type == .Photo }
				)
			}
		
		return Output(
			textColor: textColor,
			dayString: dayString,
			hasRecord: hasRecord
		)
	}
	
	private func isToday(dateString: String) -> Bool {
		if formatter.string(from: self.date) == dateString {
			return true
		}
		return false
	}
}
