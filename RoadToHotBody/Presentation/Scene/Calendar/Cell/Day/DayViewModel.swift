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
		var isDateSelected: Observable<Bool>
	}
	
	struct Output {
		var textColor: Observable<UIColor>
        var textBackgroundColor: Observable<UIColor>
		var dayString: Driver<String>
		var hasRecord: Observable<(Bool, Bool, Bool)>?
        var isToday: Observable<Bool>
	}
	
	private let fetchRecordsUseCase = FetchRecordsUseCase(repository: RecordRepository(dataSource: RecordInternalDB()))
	
	let calendarDate: CalendarDate
	private let today: Date
	private let formatter: DateFormatter
	
	var records: [Content]?
	
	init(calendarDate: CalendarDate) {
		
		self.calendarDate = calendarDate
        
		today = Date()
		formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
	}
	
	func transform(input: Input) -> Output {

        let textColor = input.isDateSelected
            .map { isSelected -> UIColor in
                if isSelected {
                    return UIColor.white
                }
                
                if self.calendarDate.isThisMonth {
                    if self.isToday(dateString: self.calendarDate.date) {
                        return UIColor.red
                    } else {
                        return UIColor.black
                    }
                } else {
                    return UIColor.lightGray
                }
            }
        
        let backgroundColor = input.isDateSelected
            .map { isSelected -> UIColor in
                if isSelected {
                    return UIColor.darkGray
                } else {
                    return UIColor.clear
                }
            }

		let dayString = Observable.just(calendarDate.dayString)
			.asDriver(onErrorJustReturn: "")
		
		let records = input.viewLoaded
			.flatMap { _ -> Observable<FetchRecordsUseCaseModels.Response> in
				self.fetchRecordsUseCase.execute(
                    request: FetchRecordsUseCaseModels.Request(date: self.calendarDate.date)
				)
			}
			.map { response -> [Content] in
				self.records = response.records
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
        
        let isToday = Observable.just(self.isToday(dateString: self.calendarDate.date))
		
		return Output(
			textColor: textColor,
            textBackgroundColor: backgroundColor,
			dayString: dayString,
			hasRecord: hasRecord,
            isToday: isToday
		)
	}
	
	private func isToday(dateString: String) -> Bool {
		if formatter.string(from: self.today) == dateString {
			return true
		}
		return false
	}
}
