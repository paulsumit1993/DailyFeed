//
//  NewsAPI.swift
//  DailyFeed
//
//  Created by Sumit Paul on 13/01/17.
//

import Foundation
import PromiseKit

enum NewsAPI {
    
    case articles(source: String)
    case sources(category: String?, language: String?, country: String?)
    case search(query: String)
    
    static var baseURL = URLComponents(string: "https://newsapi.org")
    static let apiToken = "8e58842e74f2453bb5e6e3845b386a81"
    
    //NewsAPI.org API Endpoints
    var url: URL? {
        switch self {
        case .articles(let source):
            let lSource = source
            NewsAPI.baseURL?.path = "/v2/top-headlines"
            NewsAPI.baseURL?.queryItems = [URLQueryItem(name: "sources", value: lSource),
                                           URLQueryItem(name: "apiKey", value: NewsAPI.apiToken)]
            guard let url = NewsAPI.baseURL?.url else { return nil }
            return url
            
        case .sources(let category, let language, let country):
            NewsAPI.baseURL?.path = "/v2/sources"
            NewsAPI.baseURL?.queryItems = [URLQueryItem(name: "category", value: category),
                                           URLQueryItem(name: "language", value: language),
                                           URLQueryItem(name: "country", value: country),
                                           URLQueryItem(name: "apiKey", value: NewsAPI.apiToken)]
            guard let url = NewsAPI.baseURL?.url else { return nil }
            return url
            
        case .search(let query):
            NewsAPI.baseURL?.path = "/v2/everything"
            NewsAPI.baseURL?.queryItems = [URLQueryItem(name: "q", value: query),
                                           URLQueryItem(name: "apiKey", value: NewsAPI.apiToken)]
            guard let url = NewsAPI.baseURL?.url else { return nil }
            return url
        }
    }
    
    //Fetch NewsSourceLogo from Cloudinary as news source logo is deprecated by newsapi.org
    
    static func getSourceNewsLogoUrl(source: String) -> String {
        let sourceLogoUrl = "https://res.cloudinary.com/news-logos/image/upload/v1557987666/\(source).png"
        return sourceLogoUrl
    }
    
    // Get News articles from /articles endpoint
    
    static func getNewsItems(source: String) -> Promise<Articles> {
        
        return Promise { seal in
            guard let feedURL = NewsAPI.articles(source: source).url else { seal.reject(JSONDecodingError.unknownError); return }
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
    static func getNewsSource(sourceRequestParams: NewsSourceParameters) -> Promise<Sources> {
        return Promise { seal in
            guard let sourceURL = NewsAPI.sources(category: sourceRequestParams.category,
                                                  language: sourceRequestParams.language,
                                                  country: sourceRequestParams.country).url else { seal.reject(JSONDecodingError.unknownError); return }
            
            let baseUrlRequest = URLRequest(url: sourceURL, cachePolicy: .returnCacheDataElseLoad)
            let session = URLSession.shared
            
            session.dataTask(with: baseUrlRequest, completionHandler: { (data, response, error) in
                guard error == nil else { seal.reject(error!); return }
                
                guard let data = data else { seal.reject(error!); return }
                
                do {
                    let jsonFromData =  try JSONDecoder().decode(Sources.self, from: data)
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
        }
    }
    
    static func searchNews(with query: String) -> Promise<Articles> {
        return Promise { seal in
            guard let sourceURL = NewsAPI.search(query: query).url else { seal.reject(JSONDecodingError.unknownError); return }
            
            let baseUrlRequest = URLRequest(url: sourceURL, cachePolicy: .returnCacheDataElseLoad)
            let session = URLSession.shared
            
            session.dataTask(with: baseUrlRequest, completionHandler: { (data, response, error) in
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
            }).resume()
        }
    }
}
