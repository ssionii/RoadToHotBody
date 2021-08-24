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
	}
	
	struct Output {
		var photos: Observable<[String]>
	}
	
	private let fetchPhotosUseCase = FetchPhotosUseCase(repository: RecordRepository(dataSource: RecordInternalDB()))
	
	func transform(input: Input) -> Output {
		
		let imageUrls = fetchPhotosUseCase.execute(request: FetchPhotosUseCaseModels.Request())
			.map { response -> [String] in
				response.photoUrls
			}
		
		return Output(photos: imageUrls)
	}
}
