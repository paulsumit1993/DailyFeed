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
    case sources(category: String?, language: String?)
    
    static var baseURL = URLComponents(string: "http://beta.newsapi.org")
    static let apiToken = "53b8c0ba0ea24a199f790d660b73675f"
    
    //NewsAPI.org API Endpoints
    var url: URL? {
        switch self {
            
        case .articles(let source):
            let lSource = source ?? "the-wall-street-journal"
            NewsAPI.baseURL?.path = "/v2/top-headlines"
            NewsAPI.baseURL?.queryItems = [URLQueryItem(name: NewsAPI.articles(source: nil).jsonKey, value: lSource), URLQueryItem(name: "apiKey", value: NewsAPI.apiToken)]
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
    
    static func fetchSourceNewsLogo(source: String) -> String {
        let sourceLogoUrl = "https://res.cloudinary.com/newsapi-logos/image/upload/v1492104667/\(source).png"
        return sourceLogoUrl
    }
    
    // Get News articles from /articles endpoint
    static func getNewsItems(_ source: String, completion: @escaping (ResultType<Articles>) -> Void) {
        
        guard let feedURL = NewsAPI.articles(source: source).url else { return }
        let baseUrlRequest = URLRequest(url: feedURL)
        let session = URLSession.shared
        
        session.dataTask(with: baseUrlRequest, completionHandler: { (data, response, error) in
            guard error == nil else {
                completion(ResultType.Failure(e: error!))
                return
            }
            
            guard let data = data else {
                completion(ResultType.Failure(e: error!))
                return
            }
            
            
            do {
                let jsonFromData =  try JSONDecoder().decode(Articles.self, from: data)
                completion(ResultType.Success(jsonFromData))
            } catch DecodingError.dataCorrupted(let context) {
                completion(ResultType.Failure(e: DecodingError.dataCorrupted(context)))
            } catch DecodingError.keyNotFound(let key, let context) {
                completion(ResultType.Failure(e: DecodingError.keyNotFound(key, context)))
            } catch DecodingError.typeMismatch(let type, let context) {
                completion(ResultType.Failure(e: DecodingError.typeMismatch(type, context)))
            } catch DecodingError.valueNotFound(let value, let context) {
                completion(ResultType.Failure(e: DecodingError.valueNotFound(value, context)))
            } catch {
                completion(ResultType.Failure(e:JSONDecodingError.unknownError))
            }
        }).resume()
    }
    
    // Get News source from /sources endpoint of NewsAPI
    static func getNewsSource(_ category: String?, language lang: String?, _ completion: @escaping (ResultType<Sources>) -> Void) {
        
        guard let sourceURL = NewsAPI.sources(category: category, language: lang).url else { return }
        
        let baseUrlRequest = URLRequest(url: sourceURL, cachePolicy: .returnCacheDataElseLoad)
        let session = URLSession.shared
        
        session.dataTask(with: baseUrlRequest, completionHandler: { (data, response, error) in
            guard error == nil else {
                completion(ResultType.Failure(e: error!))
                return
            }
            
            guard let data = data else {
                completion(ResultType.Failure(e: error!))
                return
            }
            
            do {
                let jsonFromData =  try JSONDecoder().decode(Sources.self, from: data)
                completion(ResultType.Success(jsonFromData))
            } catch DecodingError.dataCorrupted(let context) {
                completion(ResultType.Failure(e: DecodingError.dataCorrupted(context)))
            } catch DecodingError.keyNotFound(let key, let context) {
                completion(ResultType.Failure(e: DecodingError.keyNotFound(key, context)))
            } catch DecodingError.typeMismatch(let type, let context) {
                completion(ResultType.Failure(e: DecodingError.typeMismatch(type, context)))
            } catch DecodingError.valueNotFound(let value, let context) {
                completion(ResultType.Failure(e: DecodingError.valueNotFound(value, context)))
            } catch {
                completion(ResultType.Failure(e:JSONDecodingError.unknownError))
            }
            
            
        }).resume()
    }
    
//    static func decodeJSON(from data: Data, to type: Codable, completion: Completion) {
//        do {
//            let jsonFromData =  try JSONDecoder().decode(Sources.self, from: data)
//            completion(ResultType.Success(jsonFromData))
//        } catch DecodingError.dataCorrupted(let context) {
//            completion(ResultType.Failure(e: DecodingError.dataCorrupted(context)))
//        } catch DecodingError.keyNotFound(let key, let context) {
//            completion(ResultType.Failure(e: DecodingError.keyNotFound(key, context)))
//        } catch DecodingError.typeMismatch(let type, let context) {
//            completion(ResultType.Failure(e: DecodingError.typeMismatch(type, context)))
//        } catch DecodingError.valueNotFound(let value, let context) {
//            completion(ResultType.Failure(e: DecodingError.valueNotFound(value, context)))
//        } catch {
//            completion(ResultType.Failure(e:JSONDecodingError.unknownError))
//        }
//    }
}
