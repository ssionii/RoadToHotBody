//
//  TrainingDetail.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import RealmSwift

@objcMembers class TrainingDetail: Object {
	dynamic var index: Int = 0
	dynamic var type: Int = 0
	dynamic var content: String = ""
	dynamic var date: Date = Date()
	dynamic var trainingIndex: Int = 0
	
	override class func primaryKey() -> String? {
		return "index"
	}
	
	override class func indexedProperties() -> [String] {
		return ["index"]
	}
}
