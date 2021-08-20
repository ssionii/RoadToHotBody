//
//  MuscleRepository.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import RxSwift
import RxCocoa

protocol MuscleRepositoryProtocol {
	func fetchMuscles(direction: Direction) -> Single<[Muscle]>
}
