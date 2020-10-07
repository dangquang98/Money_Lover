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
		case serverDate = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
		case sortDate = "ddMMyyyy"
		case monthYear = "MM/yyyy"
		case day = "dd"
		case fullDay = "EEEE"
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
