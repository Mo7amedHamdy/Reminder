//
//  Date+Today.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 24/04/2022.
//

import Foundation

extension Date {
    
    var dateAndTimeText: String {
        
        //create time string
        let timeText = formatted(date: .omitted, time: .shortened) //done
        
        //make sure that day is today
        if Locale.current.calendar.isDateInToday(self) {  //done
            //translate "Today" to user locale %@=variable(ex.timeText)  //done
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time format string")
            return String(format: timeFormat, timeText)
        }
        else {
            //format for date text
            let dateText = formatted(.dateTime.month(.abbreviated).day()) //done
            let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
            return String(format: dateAndTimeFormat, dateText, timeText)  //done
        }
    }
                
    var dayText: String {
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today due date description")
        }else {
            return formatted(.dateTime.month().day().weekday(.wide))
        }
    }
    
}
