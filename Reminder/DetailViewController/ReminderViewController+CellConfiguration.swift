//
//  ReminderViewController+CellConfiguration.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 10/05/2022.
//

import UIKit

extension ReminderViewController {
    
    func defaultConfiguration(for cell: UICollectionViewListCell, at row: Row) -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        return contentConfiguration
    }
    
    func headerConfiguration(for cell: UICollectionViewListCell, with title: String) -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = title
        return contentConfiguration
    }
    
    //new
    func titleConfiguration(for cell: UICollectionViewListCell, at row: Row) -> TextFieldContentView.Configuration {
        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.text = text(for: row) //transfere text to Configuration Struct
        contentConfiguration.onChange = { [weak self] newTitle in
            self?.workingReminder.title = newTitle
        }
        return contentConfiguration
    }
    
    func dateConfiguration(for cell: UICollectionViewListCell, with date: Date) -> DatePickerContentview.Configuration {
        var contentConfiguration = cell.datePickerConfiguration()
        contentConfiguration.date = date
        contentConfiguration.onChange = { [weak self] dueDate in
            self?.workingReminder.dueDate = dueDate
        }
        return contentConfiguration
    }
    
    func notesConfiguration(for cell: UICollectionViewListCell, with notes: String?) -> TextViewContentView.Configuration {
        var contentConfiguration = cell.textViewConfiguration()
        contentConfiguration.text = notes
        contentConfiguration.onHandler = { [weak self] newNotes in
            self?.workingReminder.notes = newNotes
        }
        return contentConfiguration
    }
    
    func text(for row: Row) -> String? {
        switch row {
        case .viewDate: return reminder.dueDate.dayText
        case .viewTime: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
        case .viewNotes: return reminder.notes
        case .viewTitle: return reminder.title
        default: return nil
        }
    }
}
