//
//  ContentRepository.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import RxSwift

protocol DetailContentRepositoryProtocol {
	func fetchDetailContents(
		request: FetchDetailContentsUseCaseModels.Request
	) -> Observable<FetchDetailContentsUseCaseModels.Response>
	
	func fetchDetailContent(
		request: FetchDetailContentUseCaseModels.Request
	) -> Observable<FetchDetailContentUseCaseModels.Response>
	
	func saveDetailContent(
		request: SaveDetailContentUseCaseModels.Request
	) -> Observable<SaveDetailContentUseCaseModels.Response>
}
