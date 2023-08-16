//
//  AnimotionUnitTests.swift
//  AnimotionUnitTests
//
//  Created by Kostiantyn Kaniuka on 16.08.2023.
//

import XCTest
@testable import Animotion


class DateConvertorTest: XCTestCase {
    var sutDefault = DateConvertor()
       
 
    
    func test_DateToFloat() throws {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let referenceDate = dateFormatter.date(from: "16/08/2023 00:00")!
            let currentDate = dateFormatter.string(from: Date())
        print("➡️", currentDate)
            let floatResult = sutDefault.convertDateToNum(date: referenceDate)
            XCTAssertEqual(floatResult, 228.0, accuracy: 0.001)
        }
    }
    
    

