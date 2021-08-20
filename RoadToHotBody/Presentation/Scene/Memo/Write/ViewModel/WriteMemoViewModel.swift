//
//  WriteMemoViewModel.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/14.
//

import RxSwift
import RxCocoa

class WriteMemoViewModel {
    
    struct Input {
        var confirmButtonClicked: Observable<Void>
        var text: Observable<String?>
    }
    
    struct Output {
        var isSaved: Observable<Void>?
		var title: Driver<String>
    }
	
	internal var muscle: Muscle?
	internal var date: String?
    
	init(muscle: Muscle?, date: String?) {
        self.muscle = muscle
		self.date = date
    }
    
    func transform(input: Input) -> Output {
        return Output(isSaved: nil, title: Driver.just(""))
    }
	
	internal func dateTitle(date: String) -> String {
		let stringFormatter = DateFormatter()
		stringFormatter.dateFormat = "yyyy-M-d"

		guard let newDate = stringFormatter.date(from: date) else { return date }
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier:"ko_KR")
		dateFormatter.dateFormat = "M월 d일 EEEE"
		
		return dateFormatter.string(from: newDate)
	}
}
