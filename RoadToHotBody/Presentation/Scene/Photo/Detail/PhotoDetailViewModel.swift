//
//  PhotoViewModel.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import UIKit
import RxSwift
import RxCocoa

enum PhotoType {
	case Record
	case ContentDetail
}

class PhotoDetailViewModel {
	struct Input {
		var deletePhotoIndex: Observable<Int>
	}
	
	struct Output {
		var photos: Observable<[Photo]>
		var pageIndex: Observable<Int>
		var photoDeleted: Observable<Void>
	}
	
	private let loadImageUseCase = LoadImageUseCase()
	private let deleteDetailContentUseCase = DeleteDetailContentUseCase(repository: DetailContentRepository(dataSource: TrainingDetailInternalDB()))
	private let deleteRecordUseCase = DeleteRecordUseCase(repository: RecordRepository(dataSource: RecordInternalDB()))
	
	private let photos: [Photo]
	private let pageIndex: Int
	private let photoType: PhotoType
	
	// FIXME: photoType으로 분기치지 말자.
	init(photos: [Photo], pageIndex: Int, photoType: PhotoType) {
		self.photos = photos
		self.pageIndex = pageIndex
		self.photoType = photoType
	}
	
	func transform(input: Input) -> Output {
		
		let photos = Observable.just(self.photos)
		let pageIndex = Observable.just(self.pageIndex)
		
		switch photoType {
		case .ContentDetail:
			let photoDeleted = input.deletePhotoIndex
				.withUnretained(self)
				.flatMap { owner, index ->
					Observable<DeleteDetailContentUseCaseModels.Response> in
					return owner.deleteDetailContentUseCase.execute(request: DeleteDetailContentUseCaseModels.Request(index: index))
				}.map { reponse -> Void in
					return ()
				}
			
			return Output(photos: photos, pageIndex: pageIndex, photoDeleted: photoDeleted)
		case .Record:
			let photoDeleted = input.deletePhotoIndex
				.withUnretained(self)
				.flatMap { owner, index ->
					Observable<DeleteRecordUseCaseModels.Response> in
					return owner.deleteRecordUseCase.execute(request: DeleteRecordUseCaseModels.Request(index: index))
				}.map { reponse -> Void in
					return ()
				}
			
			return Output(photos: photos, pageIndex: pageIndex, photoDeleted: photoDeleted)
		}
	}
}
