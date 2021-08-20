//
//  ContentRepository.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import RxSwift

protocol DetailContentRepositoryProtocol {
	func fetchDetailContents(muscleIndex: Int) -> Single<[Content]>
	func saveDetailContent(muscleIndex: Int, text: String, type: ContentType) -> Completable
	func updateDetailContent(index: Int, text: String) -> Completable
	func deleteDetailContent(index: Int) -> Completable
}
