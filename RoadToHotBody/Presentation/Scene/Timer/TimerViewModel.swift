//
//  TimerViewModel.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/26.
//

import Foundation
import RxSwift
import RxCocoa

class TimerViewModel {
	struct Input {
		var isPlaying: Observable<Bool>
	}
	
	struct Output {
		var timeString: Driver<String>
	}
	
	private var tempTime = 0
	private var stopedTime = 0
	
	func transform(input: Input) -> Output {
		
		let timer = self.timer()
			.do( onNext: { time in
				self.tempTime = time
			}).share()
		
		let tiemString = input.isPlaying
			.flatMapLatest { isPlaying -> Observable<Int> in
				if isPlaying {
					return timer
				} else {
					return .empty()
				}
			}
			.do(onCompleted: { _ in
				self.tempTime =
			})
		
		
		let timeString = input.isPlaying
			.flatMapLatest { isPlaying -> Observable<Int> in
				if isPlaying {
					return self.timer()
				} else {
					return .empty()
				}
			}
			.do ( onNext: { time in
				self.tempTime = time
			})
			.map { time -> Int in
				return self.tempTime + time
			}
			.map { time -> String in
				return self.numToTime(time: time)
			}
			.asDriver(onErrorJustReturn: "")
		
		return Output(timeString: timeString)
	}
	
	private func numToTime(time: Int) -> String {
		let milliseconds = time % 10
		let sec = (time / 100) % 60
		let min = (time / 10) / 60
		
		let secString = "\(sec)".count == 1 ? "0\(sec)" : "\(sec)"
		let minString = "\(min)".count == 1 ? "0\(min)" : "\(min)"

		return "\(minString):\(secString).\(milliseconds)"
	}
	
	private func timer() -> PublishSubject<Int> {
		return Observable<Int>.interval(RxTimeInterval.milliseconds(10), scheduler: MainScheduler.instance)
	}
}
