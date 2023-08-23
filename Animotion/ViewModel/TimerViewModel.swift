//
//  TimerViewModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 23.08.2023.
//

import Foundation

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
    
    func saveTimerDates() {
        UserDefaults.standard.set(startDate, forKey: "savedStartDate")
        UserDefaults.standard.set(endDate, forKey: "savedEndDate")
    }
    
    
    func loadSavedTimerDates(completion: @escaping () -> Void) {
        startDate = UserDefaults.standard.value(forKey: "savedStartDate") as? Date
        endDate = UserDefaults.standard.value(forKey: "savedEndDate") as? Date
        
        if let endDate = endDate {
            let currentTime = Date()
            let remainingTime = Int(endDate.timeIntervalSince(currentTime))
            seconds = remainingTime
            
            if remainingTime > 0 {
                completion()
             
            } else {
                // Timer has ended, handle accordingly
            }
        }
    }
}
