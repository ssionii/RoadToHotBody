//
//  DetailContentRepositoryImpl.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import RxSwift

class DetailContentRepository: DetailContentRepositoryProtocol {
	
	private let trainingDetailDB: TrainingDetailInternalDBProtocol
	
	init(dataSource: TrainingDetailInternalDBProtocol) {
		self.trainingDetailDB = dataSource
	}
	
	func fetchDetailContents(muscleIndex: Int) -> Single<[Content]> {
		return trainingDetailDB.fetchTrainingDetails(trainingIndex: muscleIndex)
			.map { trainingDetails -> [Content] in
				return trainingDetails.map { detail -> Content in
					Content(
						index: detail.index,
						type: ContentType(rawValue: detail.type) ?? .Memo,
						text: detail.content
					)
				}
			}
	}
	
	func saveDetailContent(muscleIndex: Int, text: String, type: ContentType) -> Completable {
		return trainingDetailDB.saveTrainingDetail(trainingIndex: muscleIndex, content: text, type: type.rawValue)
	}

	func updateDetailContent(index: Int, text: String) -> Completable {
		return trainingDetailDB.updateTrainingDetail(index: index, content: text)
	}
	
	func deleteDetailContent(index: Int) -> Completable {
		return trainingDetailDB.deleteTrainingDetail(index: index)
	}
}
