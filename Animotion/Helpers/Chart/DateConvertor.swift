//
//  DateConvertor.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 16.08.2023.
//

import Foundation

final class DateConvertor {
    
    func convertDateToNum(date: Date) -> Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let year = components.year!
        let month = components.month!
        let day = components.day!
        let hour = components.hour!
        
        var dayOfYear = day
        for i in 1..<month {
            dayOfYear += self.days(forMonth: i, year: year)
        }
        
        let fractionalHour = Double(hour) / 24.0
        return Double(dayOfYear) + fractionalHour
    }
    
    private func days(forMonth month: Int, year: Int) -> Int {
           // month is 0-based
           switch month {
           case 1:
               var is29Feb = false
               if year < 1582 {
                   is29Feb = (year < 1 ? year + 1 : year) % 4 == 0
               } else if year > 1582 {
                   is29Feb = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
               }
               
               return is29Feb ? 29 : 28
               
           case 3, 5, 8, 10:
               return 30
               
           default:
               return 31
           }
       }
    
       private func determineDate(forDays days: Int) -> Date {
           var year = determineYear(forDays: days)
           var remainingDays = days
           var month = 1
           
           while remainingDays > self.days(forMonth: month, year: year) {
               remainingDays -= self.days(forMonth: month, year: year)
               month += 1
           }
           
           let day = remainingDays
           var dateComponents = DateComponents()
           dateComponents.year = year
           dateComponents.month = month
           dateComponents.day = day
           
           let calendar = Calendar.current
           return calendar.date(from: dateComponents)!
       }
    
    
    private func determineMonth(forDayOfYear dayOfYear: Int) -> Int {
        var month = -1
        var days = 0
        
        while days < dayOfYear {
            month += 1
            if month >= 12 {
                month = 0
            }
            
            let year = determineYear(forDays: days)
            days += self.days(forMonth: month, year: year)
        }
        
        return max(month, 0)
    }
    
    private func determineDayOfMonth(forDays days: Int, month: Int) -> Int {
        var count = 0
        var daysForMonth = 0
        
        while count < month {
            let year = determineYear(forDays: days)
            daysForMonth += self.days(forMonth: count % 12, year: year)
            count += 1
        }
        
        return days - daysForMonth
    }
    
    private func determineYear(forDays days: Int) -> Int {
        switch days {
        case ...365: return 2023
        case 366...730: return 2024
        case 731...1094: return 2025
        case 1095...1458: return 2026
        default: return 2027
        }
    }
}
