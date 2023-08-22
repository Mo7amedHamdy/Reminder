//
//  Reminder.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 19/04/2022.
//

import Foundation
import UIKit

struct Reminder: Equatable, Identifiable {
    
    var id: String = UUID().uuidString  //done
    var title: String
    var dueDate: Date
    var notes: String? = nil
    var isComplete: Bool = false
}

extension Array where Element == Reminder {
    func indexOfReminder(with id: Reminder.ID) -> Self.Index { //Array.Index is a type alias for Int
        guard let index = firstIndex(where: { $0.id == id }) else { fatalError() }
        return index
    }
}

