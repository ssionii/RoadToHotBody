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
        var saveTimeRecord: Observable<Void>
	}
	
	struct Output {
		var timeString: Observable<String>
        var savedTimeRecord: Observable<Void>
	}
	
	private var tempTime = 0
    
    private let saveRecordUseCase = SaveRecordUseCase(repository: RecordRepository(dataSource: RecordInternalDB()))
	
	func transform(input: Input) -> Output {
        
		let timeString = input.isPlaying
			.flatMapLatest { isPlaying in
                isPlaying ? Observable<Int>.interval(RxTimeInterval.milliseconds(10), scheduler: MainScheduler.instance) : .empty()
			}
            .map { time -> String in
                self.tempTime = time
                return self.numToTime(time: time)
            }
        
        let savedTimeRecord = input.saveTimeRecord
            .withUnretained(self)
            .map { owner, _ -> String in
                return owner.timeToMemo(time: owner.tempTime)
            }
            .flatMap { memo -> Observable<SaveRecordUseCaseModels.Response> in
                return self.saveRecordUseCase.execute(request: SaveRecordUseCaseModels.Request(text: memo, type: .Memo))
            }
            .map { response -> Void in
                return ()
            }
    
        return Output(timeString: timeString, savedTimeRecord: savedTimeRecord)
	}
    
    private func numToTime(time: Int) -> String {
        let millisec = time % 100
        let sec = (time / 100) % 60
        let min = (time / 100) / 60
        let hour = ((time / 100) / 60) % 60
        
        let millisecString = "\(millisec)".count == 1 ? "0\(millisec)" : "\(millisec)"
        let secString = "\(sec)".count == 1 ? "0\(sec)" : "\(sec)"
        let minString = "\(min)".count == 1 ? "0\(min)" : "\(min)"
        let hourString = hour == 0 ? "" : "\(hour)"

        if hour == 0 {
            return "\(minString):\(secString).\(millisecString)"
        } else {
            return "\(hourString):\(minString):\(secString)"
        }
    }
    
    private func timeToMemo(time: Int) -> String {
        let sec = (time / 100) % 60
        let min = (time / 100) / 60
        let hour = ((time / 100) / 60) % 60
        
        let secString = sec == 0 ? "" : " \(sec)초"
        let minString = min == 0 ? "" : " \(min)분"
        let hourString = hour == 0 ? "" : " \(hour)시간"
        
        return "⏱ 운동시간:\(hourString)\(minString)\(secString)"
    }
}
