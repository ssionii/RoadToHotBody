//
//  DateHelper.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/25.
//

import Foundation

class DateHelper {
	static func dateTitle(date: String, dateFormat: String) -> String {
		let stringFormatter = DateFormatter()
		stringFormatter.dateFormat = "yyyy-MM-dd"

		guard let newDate = stringFormatter.date(from: date) else { return date }
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier:"ko_KR")
		dateFormatter.dateFormat = dateFormat
		
		return dateFormatter.string(from: newDate)
	}
}
