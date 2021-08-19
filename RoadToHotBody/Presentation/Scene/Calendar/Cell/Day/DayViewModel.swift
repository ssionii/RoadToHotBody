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
	}
	
	struct Output {
		var textColor: Observable<UIColor>
		var dayString: Driver<String>
		var hasExerciseRecord: Observable<Bool>
		var hasMemoRecord: Observable<Bool>
		var hasPhotoRecord: Observable<Bool>
	}
	
	private let calendarDate: CalendarDate
	private let date: Date
	private let formatter: DateFormatter
	
	var records: PublishSubject<[Content]>()
	
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
		
		return Output(
			textColor: textColor,
			dayString: dayString,
			hasExerciseRecord: Observable.of(true),
			hasMemoRecord: Observable.of(true),
			hasPhotoRecord: Observable.of(true)
		)
	}
	
	private func isToday(dateString: String) -> Bool {
		if formatter.string(from: self.date) == dateString {
			return true
		}
		return false
	}
	
	private func fetchRecords(date: String) -> Observable<[Content]> {
		// TODO: use case에서 records fetch
		
		return Observable.just([])
	}
}
