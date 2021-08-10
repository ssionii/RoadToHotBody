//
//  ContentRepository.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import RxSwift

protocol ContentRepositoryProtocol {
	func fetchDetailContents(
		request: FetchDetailContentsUseCaseModels.Request
	) -> Observable<FetchDetailContentsUseCaseModels.Response>
}
