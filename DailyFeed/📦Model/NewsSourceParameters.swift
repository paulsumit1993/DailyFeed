//
//  NewsSourceRequestParameters.swift
//  DailyFeed
//
//  Created by Sumit Paul on 05/05/19.
//

import Foundation

struct NewsSourceParameters {
    let category: String?
    let language: String?
    let country: String?
    
    init(category: String? = nil, language: String? = nil, country: String? = nil) {
        self.category = category
        self.language = language
        self.country = country
    }
}
