//
//  TomorrowReminder+Reminder.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 20/08/2023.
//

import UIKit
import CoreData

extension TomorrowReminder {
    func update(using reminder: Reminder) {
        title = reminder.title
        notes = reminder.notes
        isComplete = reminder.isComplete
        dueDate = reminder.dueDate
        id = reminder.id
    }
}
