//
//  Record.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/19.
//

import RealmSwift

class Record: Object {
	@objc dynamic var index: Int = 0
	@objc dynamic var type: Int = 0
	@objc dynamic var content: String = ""
	@objc dynamic var date: String = ""
	@objc dynamic var trainingIndex: Int = -1
	
	override class func primaryKey() -> String? {
		return "index"
	}
	
	override class func indexedProperties() -> [String] {
		return ["index"]
	}
}
