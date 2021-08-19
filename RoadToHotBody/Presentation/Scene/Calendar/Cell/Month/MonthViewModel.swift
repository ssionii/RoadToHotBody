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
        var todayIndex: Observable<Int>?
    }
    
    private var currentYear: Int
    private var currentMonth: Int
    private var today: String
    private var numOfDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    private let formatter = DateFormatter()
    
    
    init(year: Int, month: Int, today: String) {
        self.currentYear = year
        self.currentMonth = month
        self.today = today
        
        if year % 4 == 0 {
            numOfDaysInMonth[1] = 29
        }
        
        formatter.dateFormat = "yyyy-M-d"
    }
    
    func transform(input: Input) -> Output {
        
        var calendarDates = [CalendarDate]()
        var index = 0
        var todayIndex: Observable<Int>? = nil
        
        // 이번달의 첫날 구하기[
        guard let firstDayOfWeek = self.dayOfWeek("\(currentYear)-\(currentMonth)-01") else {
            return Output(calendarDates: Observable.of([]), todayIndex: nil)
        }
        
        // 전 달
        let preYearAndMonth = preYearAndMonth(currentYear: self.currentYear, currentMonth: self.currentMonth)
        if firstDayOfWeek > 1 {
            var day = numOfDaysInMonth[preYearAndMonth.1 - 1] - firstDayOfWeek + 2
            
            for _ in 0 ... firstDayOfWeek - 2 {
                calendarDates.append(CalendarDate(isThisMonth: false, date: "\(preYearAndMonth.0)-\(preYearAndMonth.1)-\(day)", dayString: String(day)))
                
                day += 1
                index += 1
            }
        }
        
        // 이번 달
        for i in 1 ... numOfDaysInMonth[currentMonth - 1] {
            let date = "\(currentYear)-\(currentMonth)-\(i)"
            if date == today {
                todayIndex = Observable<Int>.just(index)
            }
            calendarDates.append(CalendarDate(isThisMonth: true, date: date, dayString: String(i)))
            index += 1
        }
        
        let nextYearAndMonth = nextYearAndMonth(currentYear: self.currentYear, currentMonth: self.currentMonth)
        for i in 1 ... ( 7 * 6 ) - calendarDates.count {
            calendarDates.append(CalendarDate(isThisMonth: false, date: "\(nextYearAndMonth.0)-\(nextYearAndMonth.1)-\(i)", dayString: String(i)))
        }
        
        return Output(calendarDates: Observable.just(calendarDates), todayIndex: todayIndex)
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
}
