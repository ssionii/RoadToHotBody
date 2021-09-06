//
//  Date+Extension.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/09/06.
//

import Foundation

extension Date {
	var year: Int {
		var calendar = Calendar(identifier: .gregorian)
		calendar.locale = Locale(identifier: "ko_KR")
		
		return calendar.component(.year, from: self)
	}
	
	var month: Int {
		var calendar = Calendar(identifier: .gregorian)
		calendar.locale = Locale(identifier: "ko_KR")
		
		return calendar.component(.month, from: self)
	}
	
	var day: Int {
		var calendar = Calendar(identifier: .gregorian)
		calendar.locale = Locale(identifier: "ko_KR")
		
		return calendar.component(.day, from: self)
	}
	
	var startOfMonth: Date {
		var calendar = Calendar(identifier: .gregorian)
		calendar.locale = Locale(identifier: "ko_KR")
		
		let components = calendar.dateComponents([.year, .month], from: self)
		
		return calendar.date(from: components) ?? Date()
	}
	
	var endOfMonth: Date {
		var calendar = Calendar(identifier: .gregorian)
		calendar.locale = Locale(identifier: "ko_KR")
		
		var components = DateComponents()
		components.month = 1
		components.second = -1
		
		return calendar.date(byAdding: components, to: startOfMonth) ?? Date()
	}
	
	var toString: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		
		return formatter.string(from: self)
	}
}
