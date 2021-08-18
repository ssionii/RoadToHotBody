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
		var isScrolledToFront: Observable<Bool>
	}
	
	struct Output {
		var displayedMonths: Observable<[(Int, Int)]>
		var displayedMonthString: Driver<String>
	}
	
	var currentYear = PublishSubject<Int>()
	var currentMonth = PublishSubject<Int>()
	
	init() {
		let date = Date()
		self.currentYear.onNext(Calendar.current.component(.year, from: date))
		self.currentMonth.onNext(Calendar.current.component(.month, from: date))
	}
	
	func transform(input: Input) -> Output {
		
//		Observable.combineLatest(self.currentYear, self.currentMonth)
//			.withLatestFrom(<#T##second: ObservableConvertibleType##ObservableConvertibleType#>, resultSelector: <#T##((Int, Int), ObservableConvertibleType.Element) throws -> ResultType#>)
			
		
		
		
//		let displayedMonths = input.isScrolledToFront
//			.map { isScrolledToFront -> (Int, Int) in
//				if isScrolledToFront {
//					let preYearAndMonth = self.preYearAndMonth(currentYear: self.currentYear, currentMonth: self.currentMonth)
//					self.currentYear = preYearAndMonth.0
//					self.currentMonth = preYearAndMonth.1
//				} else {
//					let nextYearAndMonth = self.nextYearAndMonth(currentYear: self.currentYear, currentMonth: self.currentMonth)
//					self.currentYear = nextYearAndMonth.0
//					self.currentMonth = nextYearAndMonth.1
//				}
//				return (self.currentYear, self.currentMonth)
//			}
//			.flatMap { (year, month) -> Observable<[(Int, Int)]> in
//				self.displayedMonths(currentYear: year, currentMonth: month)
//			}
//
//		let displayedMonthString = input.isScrolledToFront
//			.flatMap { _ -> String in
//
//			}
//
//			Observable.of("\(currentYear)년 \(currentMonth)월")
//			.asDriver(onErrorJustReturn: "")

		return Output(displayedMonths: displayedMonths, displayedMonthString: displayedMonthString)
	}
	
	private func displayedMonths(currentYear: Int, currentMonth: Int) -> Observable<[(Int, Int)]> {
		var preYear = currentYear
		var preMonth = currentMonth - 1
		if preMonth < 1 {
			preYear -= 1
			preMonth = 12
		}
		
		var nextYear = currentYear
		var nextMonth = currentMonth + 1
		if nextMonth > 12 {
			nextYear += 1
			nextMonth = 1
		}
		
		return Observable.just([
			(preYear, preMonth),
			(currentYear, currentMonth),
			(nextYear, nextMonth)
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
		var nextMonth = currentMonth + 12
		if nextMonth == 13 {
			nextYear += 1
			nextMonth = 1
		}
		return (nextYear, nextMonth)
	}
}
