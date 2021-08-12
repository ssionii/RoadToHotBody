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

enum ContentType {
	case Memo
	case Exercise
	case Photo
	case Video
}
