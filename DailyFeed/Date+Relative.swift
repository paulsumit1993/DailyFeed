//
//  Date+Relative.swift
//  DailyFeed
//
//  Created by TrianzDev on 23/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import Foundation

extension Date {

    var relativelyFormatted: String {

        let now = Date()
        let components = Calendar.autoupdatingCurrent.dateComponents([.year,
                                                                      .month,
                                                                      .weekOfYear,
                                                                      .day,
                                                                      .hour,
                                                                      .minute,
                                                                      .second],
                                                                     from: self,
                                                                     to: now)

        if let years = components.year, years > 0 {
            return "\(years) year\(years == 1 ? "" : "s") ago"
        }

        if let months = components.month, months > 0 {
            return "\(months) month\(months == 1 ? "" : "s") ago"
        }

        if let weeks = components.weekOfYear, weeks > 0 {
            return "\(weeks) week\(weeks == 1 ? "" : "s") ago"
        }
        if let days = components.day, days > 0 {
            guard days > 1 else { return "Yesterday" }

            return "\(days) day\(days == 1 ? "" : "s") ago"
        }

        if let hours = components.hour, hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        }

        if let minutes = components.minute, minutes > 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        }

        if let seconds = components.second, seconds > 30 {
            return "\(seconds) second\(seconds == 1 ? "" : "s") ago"
        }

        return "Just now"
    }

    var relativelyFormattedShort: String {

        let now = Date()
        let components = Calendar.autoupdatingCurrent.dateComponents([.year,
                                                                      .month,
                                                                      .weekOfYear,
                                                                      .day,
                                                                      .hour,
                                                                      .minute,
                                                                      .second],
                                                                     from: self,
                                                                     to: now)

        if let years = components.year, years > 0 {
            return " • \(years) y ago"
        }

        if let months = components.month, months > 0 {
            return " • \(months) mo ago"
        }

        if let weeks = components.weekOfYear, weeks > 0 {
            return " • \(weeks) w ago"
        }
        if let days = components.day, days > 0 {
            guard days > 1 else { return " • Y'day" }

            return " • \(days) d ago"
        }

        if let hours = components.hour, hours > 0 {
            return " • \(hours) h ago"
        }

        if let minutes = components.minute, minutes > 0 {
            return " • \(minutes) min ago"
        }

        if let seconds = components.second, seconds > 30 {
            return " • \(seconds) s ago"
        }

        return "Just now"
    }
}

extension String {
    var dateFromTimestamp: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let date = dateFormatter.date(from: self)
        return date

    }
}
