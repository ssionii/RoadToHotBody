//
//  CoreDataError.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/12.
//

import Foundation

struct TableNotFoundError: Error {
	var message = "테이블을 찾을 수 없습니다. (TableNotFoundError)"
	var detailMessage: String
	
	init(detailMessage: String) {
		self.detailMessage = detailMessage
	}
}

struct RealmNotInitError: Error {
	var message = "Realm이 초기화되지 않았습니다. (RealmNotFoundError)"
	var detailMessage: String
	
	init(detailMessage: String) {
		self.detailMessage = detailMessage
	}
}

struct JsonNotFoundError: Error {
	var message = "json 파일을 찾을 수 없습니다. (JsonNotFoundError)"
	var detailMessage: String
	
	init(detailMessage: String) {
		self.detailMessage = detailMessage
	}
}
