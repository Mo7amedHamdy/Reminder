//
//  Reminder+TomorrowReminder.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 20/08/2023.
//

import UIKit

extension Reminder {
    
    init(tomorrowReminder: TomorrowReminder) {
        id = tomorrowReminder.id!
        title = tomorrowReminder.title! //TODO handle this
        dueDate = tomorrowReminder.dueDate!
        notes = tomorrowReminder.notes
        isComplete = tomorrowReminder.isComplete
    }
}
