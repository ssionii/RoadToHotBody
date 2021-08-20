//
//  CalendarViewModel.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/17.
//

import RxSwift
import RxCocoa

class CalendarViewModel {
	struct Input {
		var isScrolled: Observable<Int>
	}
	
	struct Output {
		var displayedMonths: Observable<[(Int, Int)]>
		var displayedMonthString: Driver<String>
	}
	
	private var currentYear: Int
	private var currentMonth: Int
	private var currentYearAndMonthChanged = PublishSubject<Void>()
	
	init() {
		let date = Date()
		currentYear = Calendar.current.component(.year, from: date)
		currentMonth = Calendar.current.component(.month, from: date)
	}
	
	func transform(input: Input) -> Output {

		let displayedMonths = input.isScrolled
			.map { isScrolled -> (Int, Int) in
				switch isScrolled {
				case -1:
					return self.preYearAndMonth(currentYear: self.currentYear, currentMonth: self.currentMonth)
				case 1:
					return self.nextYearAndMonth(currentYear: self.currentYear, currentMonth: self.currentMonth)
				default:
					return (self.currentYear, self.currentMonth)
				}
			}
			.flatMap { year, month -> Observable<[(Int, Int)]> in
				self.currentYear = year
				self.currentMonth = month
				self.currentYearAndMonthChanged.onNext(())
				
				return self.displayedMonths(currentYear: year, currentMonth: month)
			}
		
		let displayedMonthString = currentYearAndMonthChanged
			.map { _ -> String in
				return "\(self.currentYear)년 \(self.currentMonth)월"
			}
			.asDriver(onErrorJustReturn: "")
		
		return Output(displayedMonths: displayedMonths, displayedMonthString: displayedMonthString)
	}
	
	private func displayedMonths(currentYear: Int, currentMonth: Int) -> Observable<[(Int, Int)]> {
		return Observable.just([
			self.preYearAndMonth(currentYear: currentYear, currentMonth: currentMonth),
			(currentYear, currentMonth),
			self.nextYearAndMonth(currentYear: currentYear, currentMonth: currentMonth)
		])
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
}