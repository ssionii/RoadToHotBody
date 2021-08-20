//
//  DetailContentDataSource.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/12.
//

import Foundation
import RxSwift

protocol ContentDataSourceProtocol {
	func fetchDetailContents(muscleIndex: Int) -> Single<[Content]>
	func saveContent(type: ContentType, text: String, muscleIndex: Int?, date: Int?) -> Completable
	func updateContent(index: Int, text: String) -> Completable
	func deleteContent(index: Int) -> Completable
}

class ContentDataSource: ContentDataSourceProtocol {
	
	private let trainingDetailInternalDB = TrainingDetailInternalDB()
	private let recordInternalDB = RecordInternalDB()
	
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
	
	func saveContent(type: ContentType, text: String, muscleIndex: Int?, date: Int?) -> Completable {
		
		if let muscleIndex = muscleIndex {
			return trainingDetailInternalDB.saveTrainingDetail(trainingIndex: muscleIndex, content: text, type: type.rawValue)
		}
		
		if let date = date {
			return recordInternalDB.saveRecord(date: date, content: text, type: type.rawValue, trainingIndex: nil)
		}
	}
    
    
    func updateContent(index: Int, text: String) -> Completable {
        return trainingDetailInternalDB.updateTrainingDetail(index: index, content: text)
    }
	
	func deleteContent(index: Int) -> Completable {
		return trainingDetailInternalDB.deleteTrainingDetail(index: index)
	}
}
