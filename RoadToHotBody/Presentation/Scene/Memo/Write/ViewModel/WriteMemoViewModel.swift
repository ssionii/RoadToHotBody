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
}
