//
//  DetailContentDataSource.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/12.
//

import Foundation
import RxSwift

protocol DetailContentDataSourceProtocol {
	func fetchDetailContents(muscleIndex: Int) -> Single<[Content]>
	func saveDetailContent(muscleIndex: Int, text: String, type: ContentType) -> Completable
    func updateDetailContent(index: Int, text: String) -> Completable
	func deleteDetailContent(index: Int) -> Completable
}

class DetailContentDataSource: DetailContentDataSourceProtocol {
	
	private let trainingDetailInternalDB = TrainingDetailInternalDB()
	
	func fetchDetailContents(muscleIndex: Int) -> Single<[Content]> {
		return trainingDetailInternalDB.fetchTrainingDetails(trainingIndex: muscleIndex)
			.map { (trainingDetails) -> [Content] in
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
		return trainingDetailInternalDB.saveTrainingDetail(trainingIndex: muscleIndex, content: text, type: type.rawValue)
	}
    
    
    func updateDetailContent(index: Int, text: String) -> Completable {
        return trainingDetailInternalDB.updateTrainingDetail(index: index, content: text)
    }
	
	func deleteDetailContent(index: Int) -> Completable {
		return trainingDetailInternalDB.deleteTrainingDetail(index: index)
	}
}
