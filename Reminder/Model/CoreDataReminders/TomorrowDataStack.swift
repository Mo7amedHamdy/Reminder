//
//  TomorrowDataStack.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 19/08/2023.
//

import UIKit
import CoreData

class TomorrowDataStack {
    
    static let shared = TomorrowDataStack()
    
    var isOpened: Bool = false

    private var context = (UIApplication.shared.delegate as? AppDelegate)?.persistantContainer.viewContext
    
    //fetch reminders from database
    func readAll() -> [Reminder] {
        let fetchRequest: NSFetchRequest<TomorrowReminder> = NSFetchRequest(entityName: "TomorrowReminder")
        guard let tomorrowReminders = try? context?.fetch(fetchRequest) else { fatalError("no reminders in database") }
        let reminders: [Reminder] = tomorrowReminders.compactMap { tomorrowReminder in
            return Reminder(tomorrowReminder: tomorrowReminder)
        }
        return reminders
    }
    
    //save new reminder to database
    @discardableResult
    func save(_ reminder: Reminder) -> Reminder.ID {
        var tomorrowReminder: TomorrowReminder
        if let tomorrowR = read(with: reminder.id) {
            tomorrowReminder = tomorrowR
        }else {
            guard let entityDes = NSEntityDescription.entity(forEntityName: "TomorrowReminder", in: context!) else { fatalError("no entity with this name") }
            tomorrowReminder = NSManagedObject(entity: entityDes, insertInto: context!) as! TomorrowReminder
        }
        
        tomorrowReminder.update(using: reminder)
        do {
            try context?.save()
        }
        catch let error as NSError {
            print("error: \(error.userInfo)")
        }
        return reminder.id
    }
    
    //remove reminder from database
    func remove(with id: Reminder.ID) {
        if let tomorrowR = read(with: id) {
            context?.delete(tomorrowR)
            try! context?.save()
        }
    }
    
    //read reminder from database
    private func read(with id: Reminder.ID) -> TomorrowReminder? {
        var tomorrowR: TomorrowReminder?
        let fetchRequest: NSFetchRequest<TomorrowReminder> = NSFetchRequest(entityName: "TomorrowReminder")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        guard let tomorrowRs = try! context?.fetch(fetchRequest) else {return nil}
        if tomorrowRs.isEmpty {
            print("is empty")
        }else {
            tomorrowR = tomorrowRs[0]
        }
        return tomorrowR
    }
}
