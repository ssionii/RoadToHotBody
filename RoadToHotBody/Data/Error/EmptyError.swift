//
//  EmptyError.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import Foundation

struct MusclesEmptyError: Error {
	var message = "Muscle가 비어있습니다. (MusclesEmptyError)"
	var detailMessage: String
	
	init(detailMessage: String) {
		self.detailMessage = detailMessage
	}
}


struct DetailContentEmptyError: Error {
	var message = "Detail Content가 비어있습니다. (DetailContentEmptyError)"
	var detailMessage: String
	
	init(detailMessage: String) {
		self.detailMessage = detailMessage
	}
}


struct MuscleCacheEmptyError: Error {
	var message = "Muscle 캐시가 없습니다. (MuscleCacheEmptyError)"
	var detailMessage: String
	
	init(detailMessage: String) {
		self.detailMessage = detailMessage
	}
}
