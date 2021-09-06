//
//  Record.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/19.
//

import RealmSwift

@objcMembers class Record: Object {
	dynamic var index: Int = 0
	dynamic var type: Int = 0
	dynamic var content: String = ""
	dynamic var date: String = ""
	dynamic var trainingIndex: Int = -1
	
	override class func primaryKey() -> String? {
		return "index"
	}
	
	override class func indexedProperties() -> [String] {
		return ["index"]
	}
}

extension Record {
	func toContent() -> Content {
		return Content(
			index: self.index,
			type: ContentType.init(rawValue: self.type) ?? .Memo,
			text: self.content
		)
	}
}
