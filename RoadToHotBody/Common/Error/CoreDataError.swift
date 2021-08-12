//
//  CoreDataError.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/12.
//

import Foundation


struct TableNotFoundError: Error {
	var message = "CoreData 테이블을 찾을 수 없습니다. (TableNotFoundError)"
	var detailMessage: String
	
	init(detailMessage: String) {
		self.detailMessage = detailMessage
	}
}
