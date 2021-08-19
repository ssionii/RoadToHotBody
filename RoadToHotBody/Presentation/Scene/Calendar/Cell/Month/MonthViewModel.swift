//
//  MonthViewModel.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/18.
//

import RxSwift
import RxCocoa

struct CalendarDate {
	var isThisMonth: Bool
	var date: String?
	var dayString: String
}

class MonthViewModel {
	struct Input {
		
	}
	
	struct Output {
		var calendarDates: Observable<[CalendarDate]>
	}
	
	private var currentYear: Int
	private var currentMonth: Int
	private var numOfDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	private let formatter = DateFormatter()
	
	
	init(year: Int, month: Int) {
		self.currentYear = year
		self.currentMonth = month
		
		if year % 4 == 0 {
			numOfDaysInMonth[1] = 29
		}
		
		formatter.dateFormat = "yyyy-MM-dd"
	}
	
	func transform(input: Input) -> Output {
		
		let calendarDates = self.calendarDates()
			
		return Output(calendarDates: calendarDates)
	}
	
	private func calendarDates() -> Observable<[CalendarDate]> {
		
		var calendarDates = [CalendarDate]()
		
		// 이번달의 첫날 구하기
		guard let firstDayOfWeek = self.dayOfWeek("\(currentYear)-\(currentMonth)-01") else { return .never() }
		
		// 전 달
		var preMonth = currentMonth - 1
		if preMonth < 1 {
			preMonth = 12
		}
		if firstDayOfWeek > 1 {
			var day = numOfDaysInMonth[preMonth - 1] - firstDayOfWeek + 2
			for _ in 0 ... firstDayOfWeek - 2 {
				calendarDates.append(CalendarDate(isThisMonth: false, date: nil, dayString: String(day)))

				day += 1
			}
		}
		
		// 이번 달
		for i in 1 ... numOfDaysInMonth[currentMonth - 1] {
			calendarDates.append(CalendarDate(isThisMonth: true, date: "\(currentYear)-\(currentMonth)-\(i)", dayString: String(i)))
		}
		
		for i in 1 ... ( 7 * 6 ) - calendarDates.count {
			calendarDates.append(CalendarDate(isThisMonth: false, date: nil, dayString: String(i)))
		}
		
		return Observable.just(calendarDates)
	}
	
	private func dayOfWeek(_ today: String) -> Int? {
		
		guard let todayDate = formatter.date(from: today) else { return nil }
		let myCalendar = Calendar(identifier: .gregorian)
		let weekDay = myCalendar.component(.weekday, from: todayDate)
		return weekDay
	}
}
