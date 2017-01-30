//
//  NewsAPI.swift
//  DailyFeed
//
//  Created by TrianzDev on 13/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import Foundation

enum NewsAPI {

    case articles(source: String?)
    case sources(category: String?)

    static let baseURL = "https://newsapi.org/v1"
    static let apiToken = "53b8c0ba0ea24a199f790d660b73675f"

    //URL Endpoints
    var url: URL {
        switch self {
        case .articles(let source):
            let lSource = source ?? "the-wall-street-journal"
            return URL(string: "\(NewsAPI.baseURL)/articles?source=\(lSource)&apiKey=\(NewsAPI.apiToken)")!
        case .sources(let category):
            let lCategory = category ?? ""
            return URL(string: "\(NewsAPI.baseURL)/sources?category=\(lCategory)&language=en")!
        }
    }

    var jsonKey: String {
        switch self {
        case .articles:
            return "articles"
        case .sources:
            return "sources"
        }
    }
}
