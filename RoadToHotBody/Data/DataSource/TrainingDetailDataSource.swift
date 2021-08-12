//
//  DetailContentDataSource.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/12.
//

import Foundation
import RxSwift

protocol TrainingDetailDataSourceProtocol {
	func fetchDetailContents() -> Single<[Content]>
}

class TrainingDetailDataSource: TrainingDetailDataSourceProtocol {
	
	private let trainingDetailCoreData: TrainingDetailCoreDataProtocol
	
	init(trainingDetailCoreData: TrainingDetailCoreDataProtocol) {
		self.trainingDetailCoreData = trainingDetailCoreData
	}
	
	func fetchDetailContents() -> Single<[Content]> {
		return trainingDetailCoreData.fetchTrainingDetail()
			.map { (trainingDetails) -> [Content] in
				return trainingDetails.map { detail -> Content in
					detail.toContent()
				}
			}
	}
	
}
