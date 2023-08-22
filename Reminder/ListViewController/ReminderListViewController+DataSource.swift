//
//  ReminderListViewController+DataSource.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 26/04/2022.
//

import UIKit
import UserNotifications

extension ReminderListViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    var reminderCompletedValue: String {
        NSLocalizedString("Completed", comment: "Reminder completed value")
    }
    
    var reminderNotCompletedValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not completed value")
    }
        
    private var tomorrowDataStack: TomorrowDataStack { TomorrowDataStack.shared }
    
    func prepareReminderstore() {
        //By creating a Task, you create a new unit of work
        //that executes asynchronously.
        Task {
            
            reminders = tomorrowDataStack.readAll()
            
            updateSnapshots()
            
            scheduleLocalNotification()
            
        }
    }

    //Schedules local notification with timeinterval trigger.
       func scheduleLocalNotification(){
           let center = UNUserNotificationCenter.current()
           center.removeAllPendingNotificationRequests()
           
           var count = 0
           
           for remind in reminders {
               let content = UNMutableNotificationContent()
               content.title = remind.title
               content.body = remind.notes ?? ""
               content.sound = .default
               content.userInfo = ["id": remind.id, "dueDate": remind.dueDate, "isComplete": remind.isComplete]
               content.badge = (count + 1) as NSNumber
               
               let timeIntervalForRemind = remind.dueDate.timeIntervalSince1970
               let timeIntervalNow = Date().timeIntervalSince1970
               
               if timeIntervalForRemind > timeIntervalNow && remind.isComplete == false {
                   
                   let timeToTrigger = timeIntervalForRemind - timeIntervalNow
                   
                   let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeToTrigger, repeats: false)
                   
                   // Create the request
                   let uuidString = UUID().uuidString
                   let request = UNNotificationRequest(identifier: uuidString,
                                                       content: content, trigger: trigger)
                   
                   // add our notification request
                   UNUserNotificationCenter.current().add(request) { error in
                       if error == nil {
                           print("succefully notified")
                       }
                   }
               }
               count += 1
           }
       }
    
    func cellRegisterationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id:Reminder.ID ) {
        let reminder = reminder(for: id)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.textProperties.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        contentConfiguration.secondaryText = reminder.dueDate.dateAndTimeText
        contentConfiguration.secondaryTextProperties.color = (reminder.isComplete || reminder.dueDate <= Date()) ? .red : .black
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
        cell.accessibilityCustomActions = [doneButtonAccessibilityAction(for: reminder)] //accessibility for voice over
        cell.accessibilityValue = reminder.isComplete ? reminderCompletedValue : reminderNotCompletedValue //accessibility for voice over
        cell.accessories = [.customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always)]
        
        var backgroundConfiuration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiuration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiuration
        
    }
    
    func completeReminder(with id: Reminder.ID) {
        var reminder = reminder(for: id)
        reminder.isComplete.toggle()
        update(reminder, with: id)
        updateSnapshots(reloading: [id])
    }
    
    //accessibility for voice over
    func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        let name = NSLocalizedString("Toggle completion", comment: "Reminder done button accessibility label")
        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
            self?.completeReminder(with: reminder.id)
            return true
        }
        return action
    }
    
    //circle button for complete reminders
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "circle.fill" : "circle" //ternary condition
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        button.id = reminder.id
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
    
    //access the model data
    func reminder(for id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(with: id)
        return reminders[index]
    }
    
    //add new reminder
    func addReminder(_ reminder: Reminder) {
        //Swift function parameters are constants by default.
        //You declared a local variable so that
        //you can mutate its properties within the function.
        var reminder = reminder
        do {
            let idFromStore = tomorrowDataStack.save(reminder)
            reminder.id = idFromStore
            reminders.append(reminder)
        }
    }
    
    //update the model data
    func update(_ reminder: Reminder, with id: Reminder.ID) {
        do {
            tomorrowDataStack.save(reminder)
            let index = reminders.indexOfReminder(with: id)
            reminders[index] = reminder
            scheduleLocalNotification()
        }
    }
    
    //remove reminder from arr and reminder store
    func deleteReminder(with id: Reminder.ID) {
        do {
            tomorrowDataStack.remove(with: id)
            let index = reminders.indexOfReminder(with: id)
            reminders.remove(at: index)
        }
    }
}
