//
//  DocumentRef.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore
import CoreSpotlight

/// A simple type for passing around references to documents as inputs to Action(s) etc.
///
/// Keep model types clean. See `DocumentRef+FlintAdditions` for extensions that Flint-ify this type
/// for use in URLs, NSUserActivity and Flint logging.
struct DocumentRef {
    let name: String
    let summary: String?

    init(name: String, summary: String?) {
        self.name = name
        self.summary = summary
    }
    
    var description: String { return name }
    
    var debugDescription: String { return "DocumentRef: \(name)" }
}

/// Support marshalling a document ref to/from URL route params.
extension DocumentRef: RouteParametersCodable {
    init?(from queryParameters: RouteParameters?, mapping: URLMapping) {
        guard let name = queryParameters?["name"] else {
            return nil
        }
        self.name = name
        self.summary = nil
    }
    
    func encodeAsRouteParameters(for mapping: URLMapping) -> RouteParameters? {
        return ["name": name]
    }
}

/// Support encoding and decoding as userInfo for NSUserActivity
extension DocumentRef: ActivityCodable {
    var requiredUserInfoKeys: Set<String> {
        return ["document"]
    }
    
    enum TestError: Error {
        case missingKey(name: String)
    }
    
    init(activityUserInfo: [AnyHashable:Any]?) throws {
        guard let name = activityUserInfo?["document"] as? String else {
            throw TestError.missingKey(name: "document")
        }
        let summary = activityUserInfo?["summary"] as? String
        self.init(name: name, summary: summary)
    }
    
    func encodeForActivity() -> [AnyHashable:Any]? {
        return ["document": name]
    }
}

/// Support custom NSUserActivity configuration for this type
extension DocumentRef: ActivityMetadataRepresentable {
    var metadata: ActivityMetadata {
        let searchAttributes = CSSearchableItemAttributeSet()
        searchAttributes.addedDate = Date()
        searchAttributes.kind = "Flint Demo Document"

        return .build {
            $0.title = name
            $0.thumbnail = UIImage(named: "FlintDemoDocIcon")
            $0.keywords = Set("decentralised internet patent".components(separatedBy: " "))
            $0.searchAttributes = searchAttributes
        }
    }
}
