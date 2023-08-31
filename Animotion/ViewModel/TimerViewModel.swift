//
//  TimerViewModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 23.08.2023.
//

import Foundation
import FirebaseAuth

final class TimerViewModel {
    var startDate: Date?
    var endDate: Date?
    
    var seconds = 1800
    var timer = Timer()
    var isTimerRunning = false
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format: "%02i:%02i",  minutes, seconds)
    }
    
    func saveTimerDates(completion: @escaping () -> Void) {
        guard let id = Auth.auth().currentUser?.uid else {return}
        UserDefaults.standard.set(startDate, forKey: "\(id)savedStartDate")
        UserDefaults.standard.set(endDate, forKey: "\(id)savedEndDate")
        if let endDate = endDate {
            let currentTime = Date()
            let remainingTimeInterval = endDate.timeIntervalSince(currentTime)
            let remainingTime = max(0, Int(remainingTimeInterval)) // Ensure non-negative value
            seconds = remainingTime
            if remainingTime > 0 {
                isTimerRunning = true
                completion()
            } else {
                isTimerRunning = false
            }
        }
    }
    
    
    func loadSavedTimerDates(completion: @escaping (Bool) -> Void) {
        guard let id = Auth.auth().currentUser?.uid else {return}
        startDate = UserDefaults.standard.value(forKey: "\(id)savedStartDate") as? Date
        endDate = UserDefaults.standard.value(forKey: "\(id)savedEndDate") as? Date
        
        if let endDate = endDate {
            let currentTime = Date()
            let remainingTime = Int(endDate.timeIntervalSince(currentTime))
            seconds = remainingTime
            
            if remainingTime > 0 {
                isTimerRunning = true
                completion(isTimerRunning)
                
            } else {
                isTimerRunning = false
                completion(isTimerRunning)
            }
        } else {
            completion(false)
        }
    }
    
    func formatTimeString(_ timeString: String) -> String? {
        let components = timeString.split(separator: ":")
        
        if components.count == 2,
           let minutes = Int(components[0]),
           let seconds = Int(components[1]) {
            return "\(minutes) min \(seconds) sec"
        }
        
        return nil
    }
}
