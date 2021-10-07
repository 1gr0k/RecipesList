//
//  Notifications.swift
//  RecipesList
//
//  Created by Андрей Калямин on 04.10.2021.
//

import Foundation
import UserNotifications
import UIKit

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Premission grantes: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func sheduleNotification(notufucztionType: String) {
        let content = UNMutableNotificationContent()
        
        content.title = notufucztionType
        content.body = "example"
        content.sound = UNNotificationSound.default
        content.badge = 1
    }
}
