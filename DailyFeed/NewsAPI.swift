//
//  NewsAPI.swift
//  DailyFeed
//
//  Created by Sumit Paul on 13/01/17.
//

import Foundation

public typealias JSONDictionary = [String: AnyObject]

enum NewsAPI {

    case articles(source: String?)
    case sources(category: String?)

    static var baseURL = URLComponents(string: "https://newsapi.org")
    static let apiToken = "53b8c0ba0ea24a199f790d660b73675f"

    //NewsAPI.org API Endpoints
    var url: URL? {
        switch self {
        case .articles(let source):
            let lSource = source ?? "the-wall-street-journal"
            NewsAPI.baseURL?.path = "/v1/\(NewsAPI.articles(source: nil).jsonKey)"
            NewsAPI.baseURL?.queryItems = [URLQueryItem(name: "source", value: lSource), URLQueryItem(name: "apiKey", value: NewsAPI.apiToken)]
            guard let url = NewsAPI.baseURL?.url else { return nil }
            return url
        case .sources(let category):
            let lCategory = category ?? ""
            NewsAPI.baseURL?.path = "/v1/\(NewsAPI.sources(category: nil).jsonKey)"
            NewsAPI.baseURL?.queryItems = [URLQueryItem(name: "category", value: lCategory), URLQueryItem(name: "language", value: "en")]
            guard let url = NewsAPI.baseURL?.url else { return nil }
            return url
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
