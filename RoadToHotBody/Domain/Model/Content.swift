//
//  Content.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import Foundation

struct Content {
	let index: Int
	let type: ContentType		// 콘텐츠 타입
	let text: String?			// 내용
}

enum ContentType: Int {
	case Memo = 0
	case Photo = 1
	case Video = 2
	case Exercise = 3
}
