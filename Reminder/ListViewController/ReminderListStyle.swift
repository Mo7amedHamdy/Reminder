//
//  ReminderListStyle.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 30/07/2023.
//

import UIKit

enum ReminderListStyle: Int {
    case today
    case future
    case all
    
    var name: String {
        switch self {
        case .today:
            return NSLocalizedString("Today", comment: "Today style name")
        case .future:
            return NSLocalizedString("Future", comment: "Future style name")
        case .all:
            return NSLocalizedString("All", comment: "All style name")
        }
    }
    
    func shouldInclude(date: Date) -> Bool {
        let isInToDay = Locale.current.calendar.isDateInToday(date)
        switch self {
        case .today:
            return isInToDay
        case .future:
            return (date > Date.now) && !isInToDay
        case .all:
            return true
        }
    }
}
