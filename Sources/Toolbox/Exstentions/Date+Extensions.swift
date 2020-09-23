
import UIKit

public extension Date {
    
    var isDateYesterday: Bool {
        Calendar.current.isDateInYesterday(Date())
    }
    
    var isDateToday: Bool {
        return Calendar.current.isDateInToday(Date())
    }
    
    var isDateWeekend: Bool {
        Calendar.current.isDateInWeekend(Date())
    }
    
    var isDateTomorrow: Bool {
        return Calendar.current.isDateInWeekend(Date())
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
