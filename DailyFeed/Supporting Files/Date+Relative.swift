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
    
    public func timeAgoSince() -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: self, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            let format = NSLocalizedString("%d years ago", comment:"years ago")
            return String.localizedStringWithFormat(format, year)
        }
        
        if let year = components.year, year >= 1 {
            return NSLocalizedString("Last year", comment: "Last year")
        }
        
        if let month = components.month, month >= 2 {
            let format = NSLocalizedString("%d months ago", comment:"months ago")
          return String.localizedStringWithFormat(format, month)
        }
        
        if let month = components.month, month >= 1 {
        return NSLocalizedString("Last month", comment: "Last month")
        }
        
        if let week = components.weekOfYear, week >= 2 {
            let format = NSLocalizedString("%d weeks ago", comment:"weeks ago")
        return String.localizedStringWithFormat(format, week)
        }
        
        if let week = components.weekOfYear, week >= 1 {
           return NSLocalizedString("Last week", comment: "Last week")
        }
        
        if let day = components.day, day >= 2 {
            let format = NSLocalizedString("%d days ago", comment:"days ago")
      return String.localizedStringWithFormat(format, day)
        }
        
        if let day = components.day, day >= 1 {
            return NSLocalizedString("Yesterday", comment: "Yesterday")
        }
        
        if let hour = components.hour, hour >= 2 {
            let format = NSLocalizedString("%d hours ago", comment:"hours ago")
       return String.localizedStringWithFormat(format, hour)
        }
        
        if let hour = components.hour, hour >= 1 {
             return NSLocalizedString("An hour ago", comment: "An hour ago")
        }
        
        if let minute = components.minute, minute >= 2 {
            let format = NSLocalizedString("%d minutes ago", comment:"minutes ago")
      return String.localizedStringWithFormat(format, minute)
        }
        
        if let minute = components.minute, minute >= 1 {
             return NSLocalizedString("A minute ago", comment: "A minute ago")
        }
        
        if let second = components.second, second >= 3 {
            let format = NSLocalizedString("%d seconds ago", comment:"seconds ago")
        return String.localizedStringWithFormat(format, second)
        }
        
       return NSLocalizedString("Just now", comment: "Just now")
        
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
    
    var direction: Locale.LanguageDirection {
        return NSLocale.characterDirection(forLanguage: self)
    }
}
