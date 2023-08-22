//
//  RminderViewController+Row.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 06/05/2022.
//

import UIKit

extension ReminderViewController {
    enum Row: Hashable {
        case header(String)
        case viewDate
        case viewTime
        case viewNotes
        case viewTitle
        case editText(String?)
        case editDate(Date)
        
        var imageName: String? {
            switch self {
            case .viewDate: return "calendar.circle"
            case .viewTime: return "clock"
            case .viewNotes: return "square.and.pencil"
            default: return nil
            }
        }
        
        var image: UIImage? {
            guard let imageName = imageName else { return nil}
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            let image = UIImage(systemName: imageName, withConfiguration: configuration)
            return image
        }
        
        var textStyle: UIFont.TextStyle {
            switch self {
            case .viewTitle: return .headline
            default: return .subheadline
            }
        }
    }
}
