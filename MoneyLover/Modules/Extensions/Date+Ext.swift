//
//  Date+Ext.swift
//  MoneyLover
//
//  Created by Interns on 9/9/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import Foundation

struct FormatString {
	enum Format: String {
		case fullDate = "EEEE, MMMM d, yyyy"
//		case serverDate = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
		case serverDate = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
		case sortDate = "ddMMyyyy"
		case ymd = "yyyy-MM-dd"
		case monthYear = "MM/yyyy"
		case day = "dd"
		case month = "MM"
		case fullDay = "EEEE"
		case year = "yyyy"
	}
}

extension DateFormatter {
	convenience init(format: FormatString.Format) {
		self.init()
		timeZone = TimeZone.current
		dateFormat = format.rawValue
	}

	func stringFromDate(_ date: Date?) -> String? {
		guard let date = date else {
			return nil
		}
		return string(from: date)
	}
}

extension Date {
	func getFirstLastDay() -> (start: Date?, end: Date?) {
		let calendar = Calendar.current
		let components = calendar.dateComponents([.month, .year], from: self)
		var dumComponent = DateComponents()
		dumComponent.day = -1
		dumComponent.month = 1
		guard let startOfMonth = calendar.date(from: components), let endOfMonth = calendar.date(byAdding: dumComponent, to: startOfMonth) else { return (nil, nil)}
		return (startOfMonth, endOfMonth)
	}
}
