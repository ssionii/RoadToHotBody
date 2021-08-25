//
//  PhotoViewModel.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoDetailViewModel {
	struct Input {
		var deletePhotoIndex: Observable<Int>
	}
	
	struct Output {
		var photos: Observable<[Photo]>
		var index: Observable<Int>
		var photoDeleted: Observable<Void>
	}
	
	private let loadImageUseCase = LoadImageUseCase()
	private let deleteRecordUseCase = DeleteRecordUseCase(repository: RecordRepository(dataSource: RecordInternalDB()))
	
	private let photos: [Photo]
	private let index: Int
	
	init(photos: [Photo], index: Int) {
		self.photos = photos
		self.index = index
	}
	
	func transform(input: Input) -> Output {
		
		let photoDeleted = input.deletePhotoIndex
			.withUnretained(self)
			.flatMap { owner, index ->
				Observable<DeleteRecordUseCaseModels.Response> in
				return owner.deleteRecordUseCase.execute(request: DeleteRecordUseCaseModels.Request(index: index))
			}.map { reponse -> Void in
				return ()
			}
		
		return Output(photos: Observable.just(photos), index: Observable.just(index), photoDeleted: photoDeleted)
	}
}
