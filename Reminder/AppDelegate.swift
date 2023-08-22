//
//  AppDelegate.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 19/04/2022.
//

import UIKit
import UserNotifications
import CoreData

  @main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().tintColor = .link
        UINavigationBar.appearance().backgroundColor = .white
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, error in
            if granted {
                print("notification succeeded")
            }
        }
        
        application.applicationIconBadgeNumber = 0
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //setup persistenet container
    lazy var persistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TomorrowModel")
        container.loadPersistentStores { descripsion, error in
            if let error {
                fatalError("unable to load persistant stores: \(error)")
            }
        }
        return container
    }()
}


//MARK: - local notification .. handle user action
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let content = response.notification.request.content
        guard let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window else { return }
        guard let navbarController = window.rootViewController as? UINavigationController else { return }
        let vc3 = navbarController.viewControllers[0] as! ReminderListViewController
        
        let reminder = Reminder(id: content.userInfo["id"] as! String, title: content.title, dueDate: content.userInfo["dueDate"] as! Date, notes: content.body, isComplete: content.userInfo["isComplete"] as! Bool)
//        let vc = ReminderViewController(reminder: reminder) { newReminder in
//            vc3.update(newReminder, with: newReminder.id)
//            vc3.updateSnapshots(reloading: [newReminder.id])
//        }
        vc3.updateSnapshots(reloading: [reminder.id])
//        navbarController.pushViewController(vc, animated: true)
    }
}

