
import UIKit

public extension Date {
    
    var isDateYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }
    
    var isDateToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isDateWeekend: Bool {
        Calendar.current.isDateInWeekend(self)
    }
    
    var isDateTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    func isDateThisWeek(with date: Date) -> Bool {
        return Calendar.current.isDate(date, equalTo: self, toGranularity: .weekday)
    }
    
    func isDateThisMonth(with date: Date) -> Bool {
        return Calendar.current.isDate(date, equalTo: self, toGranularity: .month)
    }
    
    func isDateThisYear(with date: Date) -> Bool {
        return Calendar.current.isDate(date, equalTo: self, toGranularity: .year)
    }
}
