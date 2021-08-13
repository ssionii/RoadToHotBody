//
//  TrainingDetail.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import RealmSwift

class TrainingDetail: Object {
	@objc dynamic var index: Int = 0
	@objc dynamic var type: Int = 0
	@objc dynamic var content: String = ""
	@objc dynamic var date: Date = Date()
	@objc dynamic var trainingIndex: Int = 0
	
//	override class func primaryKey() -> String? {
//		return "index"
//	}
//	
//	override class func indexedProperties() -> [String] {
//		return ["index"]
//	}
}
