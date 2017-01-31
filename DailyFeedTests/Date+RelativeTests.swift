//
//  Date+RelativeTests.swift
//  DailyFeed
//
//  Created by Sumit Paul on 31/01/17.
//

import XCTest
@testable import DailyFeed

class Date_RelativeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testRealtiveDateFormatter() {
        let dateStrToTest1 = Date(timeIntervalSinceNow: 1)
        let dateStrToTest2 = Date(timeIntervalSinceNow: -123)

        XCTAssertEqual(dateStrToTest1.relativelyFormatted(short: false), "Just now")
        XCTAssertEqual(dateStrToTest1.relativelyFormatted(short: true), "Just now")
        XCTAssertEqual(dateStrToTest2.relativelyFormatted(short: false), "2 minutes ago")
        XCTAssertEqual(dateStrToTest2.relativelyFormatted(short: true), " • 2 min ago")
        XCTAssertEqual(Date(timeIntervalSinceNow: -1234).relativelyFormatted(short: false), "20 minutes ago")
        XCTAssertEqual(Date(timeIntervalSinceNow: -12345).relativelyFormatted(short: false), "3 hours ago")
        XCTAssertEqual(Date(timeIntervalSinceNow: -123456).relativelyFormatted(short: false), "yesterday")
        XCTAssertEqual(Date(timeIntervalSinceNow: -1234567).relativelyFormatted(short: false), "2 weeks ago")
        XCTAssertEqual(Date(timeIntervalSinceNow: -12345689).relativelyFormatted(short: false), "4 months ago")
        XCTAssertEqual(Date(timeIntervalSinceNow: -123456890).relativelyFormatted(short: false), "3 years ago")
        XCTAssertEqual(Date(timeIntervalSinceNow: -1234568901).relativelyFormatted(short: false), "39 years ago")

    }

    func testDateFromTimeStamp() {
        let timeStamp1 = "2017-01-30T17:09:11Z"
        let timeStamp2 = "2017-01-28T23:10:24Z"
        
        let dateComponents1 = Calendar.current.dateComponents([.year,
                                                              .month,
                                                              .day,
                                                              .hour,
                                                              .minute,
                                                              .second], from: timeStamp1.dateFromTimestamp!)

        let dateComponents2 = Calendar.current.dateComponents([.year,
                                                               .month,
                                                               .day,
                                                               .hour,
                                                               .minute,
                                                               .second], from: timeStamp2.dateFromTimestamp!)

        XCTAssertEqual(dateComponents1.year, 2017)
        XCTAssertEqual(dateComponents1.month, 01)
        XCTAssertEqual(dateComponents1.day, 30)
        XCTAssertEqual(dateComponents1.hour, 22)
        XCTAssertEqual(dateComponents1.minute, 39)
        XCTAssertEqual(dateComponents1.second, 11)
        
        XCTAssertEqual(dateComponents2.year, 2017)
        XCTAssertEqual(dateComponents2.month, 01)
        XCTAssertEqual(dateComponents2.day, 29)
        XCTAssertEqual(dateComponents2.hour, 4)
        XCTAssertEqual(dateComponents2.minute, 40)
        XCTAssertEqual(dateComponents2.second, 24)
    }

    func testDateFormatterPerf() {
        self.measure {
            let timeStamp = "2017-01-30T17:09:11Z"
            
            for _ in 0...50 {
            _ = timeStamp.dateFromTimestamp
            }
        }
    }
}
