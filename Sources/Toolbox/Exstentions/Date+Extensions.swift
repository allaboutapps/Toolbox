
import UIKit

public extension Date {
    static func isDateYesterday(with date: Date) -> Bool {
        return Calendar.current.isDateInYesterday(date)
    }
    
    static func isDateToday(with date: Date) -> Bool {
        return Calendar.current.isDateInToday(date)
    }
    
    static func isDateWeekend(with date: Date) -> Bool {
        return Calendar.current.isDateInWeekend(date)
    }
    
    static func isDateTomorrow(with date: Date) -> Bool {
        return Calendar.current.isDateInWeekend(date)
    }
    
    static func isDateThisWeek(with date: Date) -> Bool {
        return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekday)
    }
    
    static func isDateThisMonth(with date: Date) -> Bool {
        return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month)
    }
    
    static func isDateThisYear(with date: Date) -> Bool {
        return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year)
    }
}
