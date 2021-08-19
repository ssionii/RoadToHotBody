//
//  DetailViewModel.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import RxSwift
import RxCocoa

class DetailViewModel {
	struct Input {
		var reloadView: Observable<Void>
        var addedPhotoURL: Observable<NSURL>
        var addedVideoURL: Observable<NSURL>
		var doExercise: Observable<Void>
	}
	
	struct Output {
		var muscleName: Driver<String>
		var contents: Observable<[Content]?>
        var isPhotoAdded: Observable<Void>
        var isVideoAdded: Observable<Void>
		var doExercise: Observable<Void>
	}
	
	// TODO: DI
	let fetchDetailContentsUseCase = FetchDetailContentsUseCase(repository: DetailContentRepository(dataSource: DetailContentDataSource()))
    let saveDetailContentUseCase = SaveDetailContentUseCase(repository: DetailContentRepository(dataSource: DetailContentDataSource()))
	let saveRecordUseCase = SaveRecordUseCase(repository: RecordRepository(dataSource: RecordDataSource()))
	
    private var contents: [Content]?
	private var muscle: Muscle
	
	init(muscle: Muscle) {
		self.muscle = muscle
	}
	
	func transform(input: Input) -> Output {
		
		let name = Observable.of(muscle.name)
			.asDriver(onErrorJustReturn: "")
		
        let content = input.reloadView
			.flatMap { _ -> Observable<FetchDetailContentsUseCaseModels.Response> in
				self.fetchDetailContentsUseCase.execute(
					request: FetchDetailContentsUseCaseModels.Request(trainingIndex: self.muscle.index)
				)
			}
			.map { response -> [Content]? in
				response.contents
			}
        
        let isPhotoAdded = input.addedPhotoURL
            .flatMap { url -> Observable<SaveDetailContentUseCaseModels.Response> in
                self.saveDetailContentUseCase.execute(
                    request: SaveDetailContentUseCaseModels.Request(
                        type: .Photo,
                        text: String(describing: url),
                        muscleIndex: self.muscle.index
                    )
                )
            }
            .map { response -> Void in
                if response.isSuccess {
                    return ()
                }
            }
        
        
        let isVideoAdded = input.addedVideoURL
            .flatMap { url -> Observable<SaveDetailContentUseCaseModels.Response> in
                self.saveDetailContentUseCase.execute(
                    request: SaveDetailContentUseCaseModels.Request(
                        type: .Video,
                        text: String(describing: url),
                        muscleIndex: self.muscle.index
                    )
                )
            }
            .map { response -> Void in
                if response.isSuccess {
                    return ()
                }
            }
		
		let doExercise = input.doExercise
			.flatMap { _ -> Observable<SaveRecordUseCaseModels.Response> in
				self.saveRecordUseCase.execute(
					request: SaveRecordUseCaseModels.Request(
						date: nil,
						text: "\(self.muscle.name) 운동 완료",
						type: .Exercise,
						muscle: self.muscle
					)
				)
			}
			.map { response -> Void in
				return ()
			}

        
		return Output(
			muscleName: name,
			contents: content,
			isPhotoAdded: isPhotoAdded,
			isVideoAdded: isVideoAdded,
			doExercise: doExercise
		)
	}
}
