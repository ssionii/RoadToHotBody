//
//  MuscleRepositoryImpl.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import RxSwift

class MuscleRepository: MuscleRepositoryProtocol {
	
	private let muscleDataSource: MuscleDataSourceProtocol
	
	private var muscleCache: [Muscle]?
	
	private let disposeBag = DisposeBag()
	
	init(dataSource: MuscleDataSourceProtocol) {
		self.muscleDataSource = dataSource
		
		self.initMuscleCache()
	}
	
	func initMuscleCache() {
		muscleDataSource.fetchMuscles()
			.subscribe(
				onSuccess: { muscles in
					self.muscleCache = muscles
				},
				onFailure: { error in
					print(MusclesEmptyError(detailMessage: error.localizedDescription))
				})
			.disposed(by: disposeBag)
		
	}
	
	func fetchMuscles(
		request: FetchMuscleUseCaseModels.Request
	) -> Observable<FetchMuscleUseCaseModels.Response> {
		
		return Observable<FetchMuscleUseCaseModels.Response>.create { [weak self] emit in
			guard let self = self else { return Disposables.create { } }
			if let cache = self.muscleCache {
				let filteredMuscles = cache.filter { $0.direction == request.direction || $0.direction == Direction.Both }
				emit.onNext(FetchMuscleUseCaseModels.Response(muscles: filteredMuscles))
			} else {
				emit.onError(MuscleCacheEmptyError(detailMessage: ""))
			}
			
			return Disposables.create { }
		}
	}
}
