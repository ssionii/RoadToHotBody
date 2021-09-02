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
	let fetchDetailContentsUseCase = FetchDetailContentsUseCase(repository: DetailContentRepository(dataSource: TrainingDetailInternalDB()))
    let saveDetailContentUseCase = SaveContentUseCase(repository: DetailContentRepository(dataSource: TrainingDetailInternalDB()))
	let saveRecordUseCase = SaveRecordUseCase(repository: RecordRepository(dataSource: RecordInternalDB()))
	
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
					request: FetchDetailContentsUseCaseModels.Request(muscleIndex: self.muscle.index)
				)
			}
			.map { response -> [Content]? in
				response.contents
			}
        
        let isPhotoAdded = input.addedPhotoURL
            .flatMap { url -> Observable<SaveContentUseCaseModels.Response> in
                self.saveDetailContentUseCase.execute(
                    request: SaveContentUseCaseModels.Request(
						muscleIndex: self.muscle.index,
						text: String(describing: url),
						type: .Photo
                    )
                )
            }
            .map { response -> Void in
                return ()
            }
        
        
        let isVideoAdded = input.addedVideoURL
            .flatMap { url -> Observable<SaveContentUseCaseModels.Response> in
                self.saveDetailContentUseCase.execute(
                    request: SaveContentUseCaseModels.Request(
						muscleIndex: self.muscle.index,
						text: String(describing: url),
                        type: .Video
                    )
                )
            }
            .map { response -> Void in
               	return ()
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
