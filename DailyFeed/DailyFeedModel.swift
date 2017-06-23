//
//  DailyFeedModel.swift
//  DailyFeed
//
//  Created by Sumit Paul on 27/12/16.
//

import MobileCoreServices

enum DailyFeedModelUTI {
    static let kUUTTypeDailyFeedModel = "kUUTTypeDailyFeedModel"
}

enum DailyFeedModelError: Error {
    case invalidTypeIdentifier
    case invalidDailyFeedModel
}

struct Articles: Codable {
    var articles: [DailyFeedModel]
}

//Data Model
class DailyFeedModel: NSObject, Serializable {
    
    public var title: String = ""
    public var author: String?
    public var publishedAt: String?
    public var urlToImage: String?
    public var articleDescription: String?
    public var url: String?
    
    private enum CodingKeys: String, CodingKey {
        case articleDescription = "description"
        case title, author, publishedAt, urlToImage, url
    }
    
    
//    static var readableTypeIdentifiersForItemProvider: [String] = [DailyFeedModelUTI.kUUTTypeDailyFeedModel]
//
//    required init(itemProviderData data: Data, typeIdentifier: String) throws {
//        if typeIdentifier == DailyFeedModelUTI.kUUTTypeDailyFeedModel {
//            if let dailyFeedModel = try self.deserialize(data: data) {
//                self.title = dailyFeedModel.title
//                self.author = dailyFeedModel.author
//                self.publishedAt = dailyFeedModel.publishedAt
//                self.urlToImage = dailyFeedModel.urlToImage
//                self.articleDescription = dailyFeedModel.articleDescription
//                self.url = dailyFeedModel.url
//            } else {
//                throw DailyFeedModelError.invalidDailyFeedModel
//            }
//        } else {
//            throw DailyFeedModelError.invalidTypeIdentifier
//        }
//    }
}

extension DailyFeedModel: NSItemProviderWriting {
    
    static var writableTypeIdentifiersForItemProvider: [String] = [DailyFeedModelUTI.kUUTTypeDailyFeedModel, kUTTypeUTF8PlainText as String]
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        if typeIdentifier == DailyFeedModelUTI.kUUTTypeDailyFeedModel {
            completionHandler(self.serialize(), nil)
        } else if typeIdentifier == kUTTypeUTF8PlainText as String {
            completionHandler(self.url?.data(using: .utf8), nil)
        } else {
            completionHandler(nil, DailyFeedModelError.invalidDailyFeedModel)
        }
        return nil
    }
}

//extension DailyFeedModel: NSItemProviderReading { }

