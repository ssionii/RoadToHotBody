//
//  Content.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import Foundation

struct Content {
	let type: ContentType		// 콘텐츠 타입
	let text: String?			// 텍스트 (메모, 운동 기록)
	let url: String?				// 사진, 비디오 url
}

enum ContentType {
	case Memo
	case Exercise
	case Photo
	case Video
}
