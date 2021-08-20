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
    
    private let saveDetailContentUseCase = SaveDetailContentUseCase(repository: DetailContentRepository(dataSource: DetailContentDataSource()))
    private let saveRecordUseCase = SaveRecordUseCase(repository: RecordRepository(dataSource: RecordDataSource()))
	
    private var muscle: Muscle?
	private var date: String?
    
	init(muscle: Muscle?, date: String?) {
        self.muscle = muscle
		self.date = date
    }
    
    func transform(input: Input) -> Output {
		
		if let muscle = self.muscle {
			let isSaved = input.confirmButtonClicked
				.withLatestFrom(input.text)
				.compactMap { $0 }
				.flatMap({ text -> Observable<SaveDetailContentUseCaseModels.Response> in
					self.saveDetailContentUseCase.execute(
						request: SaveDetailContentUseCaseModels.Request(type: .Memo, text: text, muscleIndex: muscle.index)
					)
				})
				.map({ response -> Void in
					return ()
				})
			
			return Output(isSaved: isSaved, title: Driver.just(""))
		}
		
		if let date = self.date {
			let isSaved = input.confirmButtonClicked
				.withLatestFrom(input.text)
				.compactMap { $0 }
				.flatMap({ text -> Observable<SaveRecordUseCaseModels.Response> in
					self.saveRecordUseCase.execute(
						request: SaveRecordUseCaseModels.Request(date: date, text: text, type: .Memo, muscle: nil)
					)
				})
				.map({ response -> Void in
					return ()
				})
			
			let title = Observable.just(dateTitle(date: date))
				.asDriver(onErrorJustReturn: "")
				
			return Output(isSaved: isSaved, title: title)
		}
        
        return Output(isSaved: nil, title: Driver.just(""))
    }
	
	private func dateTitle(date: String) -> String {
		let stringFormatter = DateFormatter()
		stringFormatter.dateFormat = "yyyy-M-d"

		guard let newDate = stringFormatter.date(from: date) else { return date }
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier:"ko_KR")
		dateFormatter.dateFormat = "M월 d일 EEEE"
		
		return dateFormatter.string(from: newDate)
	}
}
