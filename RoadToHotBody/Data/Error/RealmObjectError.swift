//
//  RealmObjectError.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import Foundation

struct TrainingDetailNotFoundError: Error {
	var message = "찾는 TrainingDetail이 없습니다. (TrainingDetailNotFoundError)"
	var detailMessage: String
	
	init(detailMessage: String) {
		self.detailMessage = detailMessage
	}
}
