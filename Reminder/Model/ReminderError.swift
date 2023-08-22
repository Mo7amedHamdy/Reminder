//
//  ReminderError.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 17/08/2023.
//

import Foundation

//Types conforming to LocalizedError can provide localized messages
//that describe their errors and why they occur.
enum ReminderError: LocalizedError {
    
    case accessDenied
    
    case accessRestricted
    
    case failedReadingCalenderItem
    
    //The LocalizedError protocol provides a default implementation
    //of the errorDescription property that returns a nonspecific message.
    case failedReadingReminders
    
    //The Reminders app doesn’t require due dates on reminders.
    //However, the myReminder app requires due dates on reminders so that
    //your users can focus on their most immediate tasks.
    case reminderHasNoDueDate
    
    case unknown
    
    //Because LocalizedError provides a default implementation,
    //you’re not required to implement this property.
    //However, your users benefit from clear information about why errors occur.
    var errorDescripsion: String? {
        switch self {
        case .accessDenied:
            return NSLocalizedString("The app doesn't have permission to read reminders", comment: "access denied error descripsion")
        case .accessRestricted:
            return NSLocalizedString("The device dosen't allow access to reminders", comment: "access restriction error descripsion")
        case .failedReadingCalenderItem:
            return NSLocalizedString("Failed to read a calender item", comment: "failed reading calender item error descripsion")
        case .failedReadingReminders:
            return NSLocalizedString("Failed to read reminders.", comment: "failed reading reminders error descripsion")
        case .reminderHasNoDueDate:
            return NSLocalizedString("A reminder has no due date.", comment: "reminder has no due date error descripsion")
        case .unknown:
            return NSLocalizedString("An unknown error occured", comment: "unknown error descripsion")
        }
    }
}
