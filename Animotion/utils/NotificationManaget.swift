//
//  NotificationManaget.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 30.08.2023.
//

import UserNotifications
import UIKit

final class NotificationManager {
    private let center = UNUserNotificationCenter.current()
    
    func setupNotifications(id:String = "capturing", date: Date?) {
        if date != nil {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date ?? Date())
            let minute = calendar.component(.minute, from: date ?? Date())
            let second = calendar.component(.second, from: date ?? Date())
            let day = calendar.component(.day, from: date ?? Date())
            let month = calendar.component(.month, from: date ?? Date())
            let content = UNMutableNotificationContent()
            content.title = "Animotion"
            content.subtitle = "Hey! Please tell me how are you? 🙂"
            content.sound = .default
            let badgeNumber = UIApplication.shared.applicationIconBadgeNumber
            content.badge = (badgeNumber + 1) as NSNumber
            var operationDate = DateComponents(calendar: calendar, timeZone:  TimeZone.current)
            operationDate.hour = hour
            operationDate.minute = minute
            operationDate.second = second
            operationDate.month = month
            operationDate.day = day
            //Trigger
            let trigger = UNCalendarNotificationTrigger(dateMatching: operationDate, repeats: false)
            //Request
            let requst = UNNotificationRequest(
                identifier: id, content: content,trigger: trigger
            )
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
            UNUserNotificationCenter.current().add(requst)
            
        }
    }
    
    struct NofificationInfo {
        let startingTime: String
        let deviceId: String
    }
    
    func setupDailyNotification(id: String = "Morning") {
        let content = UNMutableNotificationContent()
        let calendar = Calendar.current
        let badgeNumber = UIApplication.shared.applicationIconBadgeNumber
        content.badge = (badgeNumber + 1) as NSNumber
        content.title = "Animotion"
        content.body = "Good morning! How do you feel? 🙂"
        content.sound = .default
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = 9
        dateComponents.minute = 0
        //Trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //Request
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().add(request)
    }
}

