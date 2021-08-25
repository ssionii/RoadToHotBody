//
//  PhotoGridViewModel.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import RxSwift
import RxCocoa

class PhotoGridViewModel {
	struct Input {
		var reloadView: Observable<Void>
	}
	
	struct Output {
		var photos: Observable<[Photo]>
	}
	
	private let fetchPhotosUseCase = FetchPhotosUseCase(repository: RecordRepository(dataSource: RecordInternalDB()))
	
	func transform(input: Input) -> Output {
		
		let photos = input.reloadView
			.withUnretained(self)
			.flatMap { owner, _ -> Observable<FetchPhotosUseCaseModels.Response> in
				owner.fetchPhotosUseCase.execute(request: FetchPhotosUseCaseModels.Request())
			}
			.map { response -> [Photo] in
				response.photos
			}
	
		return Output(photos: photos)
	}
}
