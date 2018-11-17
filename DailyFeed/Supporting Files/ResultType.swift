//
//  Result.swift
//  DailyFeed
//
//  Created by Sumit Paul on 20/06/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import Foundation

// swift result type https://www.cocoawithlove.com/blog/2016/08/21/result-types-part-one.html#the-result-type

enum ResultType<T> {
    case Success(T)
    case Failure(e: Error)
}
