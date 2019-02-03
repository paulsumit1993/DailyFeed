//
//  NewsAPI.swift
//  DailyFeed
//
//  Created by Sumit Paul on 13/01/17.
//

import Foundation
import PromiseKit

public typealias JSONDictionary = [String: AnyObject]

enum NewsAPI {
    
    case articles(category: String?)
    case sources(category: String?, language: String?)
    
    static var baseURL = URLComponents(string: "https://newsapi.org")
    static let apiToken = "adbe34f12ddf47719766fb9b79adb637" // phisakel@gmail.com
    
    //NewsAPI.org API Endpoints
    var url: URL? {
        switch self {
            
        case .articles(let category):
            //let lSource = source ?? ""
            NewsAPI.baseURL?.path = "/v2/top-headlines"
            //if lSource.isEmpty {
                var regionCode = Locale.current.regionCode!
                if regionCode.caseInsensitiveCompare("cy") == .orderedSame { regionCode = "gr"}
                NewsAPI.baseURL?.queryItems = [URLQueryItem(name: "country", value: regionCode), URLQueryItem(name: "category", value: category!), URLQueryItem(name: "apiKey", value: NewsAPI.apiToken)]
            //} else {
            //    NewsAPI.baseURL?.queryItems = [URLQueryItem(name: NewsAPI.articles(source: nil, category: nil).jsonKey, value: lSource), ///URLQueryItem(name: "apiKey", value: NewsAPI.apiToken)]
            //}
            guard let url = NewsAPI.baseURL?.url else { return nil }
            return url
            
        case .sources(let category, let language):
            //let lCategory = category ?? ""
            NewsAPI.baseURL?.path = "/v2/\(NewsAPI.sources(category: nil, language: nil).jsonKey)"
            NewsAPI.baseURL?.queryItems = [URLQueryItem(name: "category", value: category), URLQueryItem(name: "language", value: language), URLQueryItem(name: "apiKey", value: NewsAPI.apiToken)]
            guard let url = NewsAPI.baseURL?.url else { return nil }
            return url
        }
    }
    
    var jsonKey: String {
        switch self {
        case .articles, .sources:
            return "sources"
        }
    }
    
    //Fetch NewsSourceLogo from Cloudinary as news source logo is deprecated by newsapi.org
    /*
    static func getSourceNewsLogoUrl(source: String) -> String {
        guard source.count > 2 else {
            return "language"
        }
        let sourceLogoUrl = "https://res.cloudinary.com/newsapi-logos/image/upload/v1492104667/\(source).png"
        return sourceLogoUrl
    } */
    
    // Get News articles from /articles endpoint
    
    static func getNewsItems(category: String) -> Promise<Articles> {
        
        return Promise { seal in
            guard let feedURL = NewsAPI.articles(category: category).url else { seal.reject(JSONDecodingError.unknownError); return }
            let baseUrlRequest = URLRequest(url: feedURL)
            let session = URLSession.shared
        
            session.dataTask(with: baseUrlRequest) { (data, response, error) in
                
                guard error == nil else { seal.reject(error!); return }
                
                guard let data = data else { seal.reject(error!); return }
                
                do {
                    let jsonFromData =  try JSONDecoder().decode(Articles.self, from: data)
                    seal.fulfill(jsonFromData)
                } catch DecodingError.dataCorrupted(let context) {
                    seal.reject(DecodingError.dataCorrupted(context))
                } catch DecodingError.keyNotFound(let key, let context) {
                    seal.reject(DecodingError.keyNotFound(key, context))
                } catch DecodingError.typeMismatch(let type, let context) {
                    seal.reject(DecodingError.typeMismatch(type, context))
                } catch DecodingError.valueNotFound(let value, let context) {
                    seal.reject(DecodingError.valueNotFound(value, context))
                } catch {
                    seal.reject(JSONDecodingError.unknownError)
                }
            }.resume()
        }
    }
    
    // Get News source from /sources endpoint of NewsAPI
    static func getNewsSource(_ category: String?, language lang: String?) -> Promise<Sources> {
        return Promise { seal in
            let catIDs = ["general","business", "entertainment", "health", "science", "sport", "technology"]
            let catSources = catIDs.map { c in DailySourceModel(langCode: Locale.current.languageCode!, category: c, description: NSLocalizedString("category_\(c)", comment: c)) }
            let fixesSources = Sources(sources: catSources)
             seal.fulfill(fixesSources)
            /*
            guard let sourceURL = NewsAPI.sources(category: category, language: lang).url else { seal.reject(JSONDecodingError.unknownError); return }
            
            let baseUrlRequest = URLRequest(url: sourceURL, cachePolicy: .returnCacheDataElseLoad)
            let session = URLSession.shared
            
            session.dataTask(with: baseUrlRequest, completionHandler: { (data, response, error) in
                guard error == nil else { seal.reject(error!); return }
                
                guard let data = data else { seal.reject(error!); return }
                
                do {
                    var jsonFromData: Sources = try JSONDecoder().decode(Sources.self, from: data)
                    if jsonFromData.sources.count == 0 {
                        let langSource = DailySourceModel(langCode: lang ?? "")
                        jsonFromData.sources = [langSource]
                    }
                    seal.fulfill(jsonFromData)
                } catch DecodingError.dataCorrupted(let context) {
                    seal.reject(DecodingError.dataCorrupted(context))
                } catch DecodingError.keyNotFound(let key, let context) {
                    seal.reject(DecodingError.keyNotFound(key, context))
                } catch DecodingError.typeMismatch(let type, let context) {
                    seal.reject(DecodingError.typeMismatch(type, context))
                } catch DecodingError.valueNotFound(let value, let context) {
                    seal.reject(DecodingError.valueNotFound(value, context))
                } catch {
                    seal.reject(JSONDecodingError.unknownError)
                }
            }).resume()
             */
        }
    }
}
