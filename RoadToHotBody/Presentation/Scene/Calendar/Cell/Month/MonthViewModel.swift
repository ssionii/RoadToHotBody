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
    var date: String
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
        
		let calendarDates = Observable.just(configureCalendarDates())
        
        return Output(calendarDates: calendarDates)
    }
	
	private func configureCalendarDates() -> [CalendarDate] {
		var calendarDates = [CalendarDate]()
		
		// 이번달의 첫날 구하기
        guard let firstDayOfWeek = self.dayOfWeek(dateString(year: currentYear, month: currentMonth, day: 1)) else {
			return []
		}
		
		// 전 달
		let preYearAndMonth = self.preYearAndMonth(currentYear: self.currentYear, currentMonth: self.currentMonth)
		if firstDayOfWeek > 1 {
			var day = numOfDaysInMonth[preYearAndMonth.1 - 1] - firstDayOfWeek + 2
			for _ in 0 ... firstDayOfWeek - 2 {
                calendarDates.append(CalendarDate(isThisMonth: false, date: dateString(year: preYearAndMonth.0, month: preYearAndMonth.1, day: day), dayString: String(day)))
				day += 1
			}
		}
		
		// 이번 달
		for i in 1 ... numOfDaysInMonth[currentMonth - 1] {
			let date = dateString(year: currentYear, month: currentMonth, day: i)
			calendarDates.append(CalendarDate(isThisMonth: true, date: date, dayString: String(i)))
		}
		
		let nextYearAndMonth = self.nextYearAndMonth(currentYear: self.currentYear, currentMonth: self.currentMonth)
		for i in 1 ... ( 7 * 6 ) - calendarDates.count {
            calendarDates.append(CalendarDate(isThisMonth: false, date: dateString(year: nextYearAndMonth.0, month: nextYearAndMonth.1, day: i), dayString: String(i)))
		}
		
		return calendarDates
	}
    
    private func preYearAndMonth(currentYear: Int, currentMonth: Int) -> (Int, Int) {
        var preYear = currentYear
        var preMonth = currentMonth - 1
        if preMonth == 0 {
            preYear -= 1
            preMonth = 12
        }
        return (preYear, preMonth)
    }
    
    private func nextYearAndMonth(currentYear: Int, currentMonth: Int) -> (Int, Int) {
        var nextYear = currentYear
        var nextMonth = currentMonth + 1
        if nextMonth == 13 {
            nextYear += 1
            nextMonth = 1
        }
        return (nextYear, nextMonth)
    }
    
    private func dayOfWeek(_ today: String) -> Int? {
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    private func dateString(year: Int, month: Int, day: Int) -> String {
        let monthString = "\(month)".count == 1 ? "0\(month)" : "\(month)"
        let dayString = "\(day)".count == 1 ? "0\(day)" : "\(day)"
        
        return "\(year)-\(monthString)-\(dayString)"
    }
}
