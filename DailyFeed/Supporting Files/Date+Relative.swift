//
//  Date+Relative.swift
//  DailyFeed
//
//  Created by LittleBiteOfCocoa on 23/01/17.
//  Copyright © littlebitesofcocoa.com. All rights reserved.
//

import Foundation

extension Date {

    func relativelyFormatted(short: Bool) -> String {

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
            return short ? "\(years)y" : "\(years) year\(years == 1 ? "" : "s") ago"
        }

        if let months = components.month, months > 0 {
            return short ? "\(months)mo" : "\(months) month\(months == 1 ? "" : "s") ago"
        }

        if let weeks = components.weekOfYear, weeks > 0 {
            return short ? "\(weeks)w" : "\(weeks) week\(weeks == 1 ? "" : "s") ago"
        }
        if let days = components.day, days > 0 {
            guard days > 1 else { return short ? "  y'day" : "yesterday" }

            return short ? "\(days)d" : "\(days) day\(days == 1 ? "" : "s") ago"
        }

        if let hours = components.hour, hours > 0 {
            return short ? "\(hours)h" : "\(hours) hour\(hours == 1 ? "" : "s") ago"
        }

        if let minutes = components.minute, minutes > 0 {
            return short ? "\(minutes) min" : "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        }

        if let seconds = components.second, seconds > 30 {
            return short ? "\(seconds)s" : "\(seconds) second\(seconds == 1 ? "" : "s") ago"
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
    
    var languageStringFromISOCode: String {
        let locale = Locale.current
        guard let languageString = locale.localizedString(forLanguageCode: self) else { return self }
        return languageString
    }
    
    var formattedCountryDescription: String {
        return countryFlagFromCountryCode + " " + countryStringFromCountryCode
    }
    
    var countryStringFromCountryCode: String {
        let locale = Locale.current
        guard let languageString = locale.localizedString(forRegionCode: self) else { return self }
        return languageString
    }
    
    var countryFlagFromCountryCode: String {
        let base : UInt32 = 127397
        var s = ""
        for v in self.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
    
    var direction: Locale.LanguageDirection {
        return NSLocale.characterDirection(forLanguage: self)
    }
}
