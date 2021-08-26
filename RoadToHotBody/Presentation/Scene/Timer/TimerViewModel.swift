//
//  TimerViewModel.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/26.
//

import Foundation
import RxSwift

class TimerViewModel {
	struct Input {
		var isPlaying: Observable<Bool>
	}
	
	struct Output {
		var time: Observable<Int>
	}
	
	func transform(input: Input) -> Output {
		
		let time = input.isPlaying
			.flatMapLatest { isPlaying -> Observable<Int> in
				if isPlaying {
					return Observable<Int>.interval(RxTimeInterval.milliseconds(10), scheduler: MainScheduler.instance)
				} else {
					return .empty()
				}
			}
		
		return Output(time: time)
	}
}
