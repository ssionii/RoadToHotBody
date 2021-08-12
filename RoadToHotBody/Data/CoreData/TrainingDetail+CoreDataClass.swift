//
//  TrainingDetail+CoreDataClass.swift
//  
//
//  Created by  60117280 on 2021/08/12.
//
//

import Foundation
import CoreData

@objc(TrainingDetail)
public class TrainingDetail: NSManagedObject {
	func toContent() -> Content {
		return Content(
			index: Int(self.index),
			type: ContentType.init(rawValue: Int(self.type)) ?? .Memo,
			text: self.content
		)
	}
}
