//
//  Muscle.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import Foundation

struct Muscle {
	var index: Int
	var name: String
	var direction: Direction
}

enum Direction: Int {
	case Both = 0
	case Front = 1
	case Back = 2
}
