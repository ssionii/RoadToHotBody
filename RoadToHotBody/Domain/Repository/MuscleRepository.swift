//
//  MuscleRepository.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import RxSwift

protocol MuscleRepositoryProtocol {
	func fetchMuscles(request: FetchMuscleUseCaseModels.Request) -> Observable<FetchMuscleUseCaseModels.Response>
}
