//
//  MuscleRepositoryImpl.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import RxSwift

class MuscleRepository: MuscleRepositoryProtocol {
	
	private let trainingDB: TrainingInternalDBProtocol
	private var muscleCache: [Muscle]?
	
	private let disposeBag = DisposeBag()
	
	init(dataSource: TrainingInternalDBProtocol) {
		self.trainingDB = dataSource
		
		self.initMuscleCache()
	}
	
	private func initMuscleCache() {
		self.fetchTrainingFromDB()
			.subscribe(
				onSuccess: { muscles in
					self.muscleCache = muscles
				},
				onFailure: { error in
					print(MusclesEmptyError(detailMessage: error.localizedDescription))
				})
			.disposed(by: disposeBag)
	}
	
	private func fetchTrainingFromDB() -> Single<[Muscle]> {
		return trainingDB.fetchTrainings()
			.map { trainings -> [Muscle] in
				return trainings.map { training -> Muscle in
					training.toMuscle()
				}
			}
	}
	
	func fetchMuscles(direction: Direction) -> Single<[Muscle]> {
		
		return Single<[Muscle]>.create { [weak self] single in
			guard let self = self else { return Disposables.create { } }
			if let cache = self.muscleCache {
				let filteredMuscles = cache.filter { $0.direction == direction || $0.direction == Direction.Both }
				single(.success(filteredMuscles))
			} else {
				single(.failure(MuscleCacheEmptyError(detailMessage: "")))
			}
			return Disposables.create { }
		}
	}
}
