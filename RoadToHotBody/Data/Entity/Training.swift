//
//  MuscleJsonModel.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import Foundation

struct TrainingJson: Codable {
	let training: [Training]
}

struct Training: Codable {
	var index: Int
	var name: String
	var direction: Int
}

extension Training {
	func toMuscle() -> Muscle {
		return Muscle(
			index: self.index,
			name: self.name,
			direction: Direction(rawValue: self.direction) ?? .Front
		)
	}
}

